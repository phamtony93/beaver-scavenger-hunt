// Packages
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
// Screens
import 'clue_screen.dart';
import 'hunt_complete_screen.dart';
// Models
import '../models/user_details_model.dart';
import '../models/clue_location_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/add_end_time.dart';
// Styles
import '../styles/styles_class.dart';

class CorrectSolutionScreen extends StatefulWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final beginTime;

  CorrectSolutionScreen({
    this.allLocations, 
    this.whichLocation, 
    this.allChallenges, 
    this.userDetails, 
    this.beginTime
  });

  @override
  _CorrectSolutionScreenState createState() => _CorrectSolutionScreenState();
}

class _CorrectSolutionScreenState extends State<CorrectSolutionScreen> {

  Completer<GoogleMapController> _controller = Completer();
  LocationData locationData;
  StreamController<LocationData> _locationController = StreamController<LocationData>();
  Stream<LocationData> get locationStream => _locationController.stream;
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double myDeviceLat;
  double myDeviceLong;
  double distanceAway;
  double screenLat;
  double screenLong;
  double zoomAmount;
  Set<Marker> myMarkers = {};
  
  void initState(){
    super.initState();
    updateDeviceLocation();
    retrieveLocation();
    screenLat = widget.allLocations[widget.whichLocation].latitude;
    screenLong = widget.allLocations[widget.whichLocation].longitude;
    zoomAmount = 15;
    
    //make marker for clue location
    Marker OSU = Marker(
      markerId: MarkerId("${widget.allLocations[widget.whichLocation].solution}"),
      position: LatLng(screenLat, screenLong),
      infoWindow: InfoWindow(title: "${widget.allLocations[widget.whichLocation].solution}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
    );

    //add location marker to map
    myMarkers.add(OSU);
  }

  // Function for updating the GPS location of device
  void updateDeviceLocation() async {
    // request location services
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
      return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
      return;
      }
    }
    _locationData = await location.getLocation();

    // this function listens for a change in location,
    // and runs when that happens
    location.onLocationChanged.listen((LocationData currentLocation) {
      //device lat and long are updated
      setState(() {
        myDeviceLat = currentLocation.latitude;
        myDeviceLong = currentLocation.longitude;
      });
      //Calculate device's distance from location
      distanceAway = calculateDistance(
        myDeviceLat, 
        myDeviceLong, 
        widget.allLocations[widget.whichLocation].latitude, 
        widget.allLocations[widget.whichLocation].longitude
      );
      
      //When user gets within 50 meters
      if (distanceAway < 50 && widget.allLocations[widget.whichLocation].found == false){
        //mark clueLocation as found
        widget.allLocations[widget.whichLocation].found = true;
        
        //for first 9 clues
        if (widget.whichLocation < widget.allLocations.length - 1){
          //update object
          widget.allLocations[widget.whichLocation + 1].available = true;
          //update db
          Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.found': true});
          Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 2}.available': true});
          //return to clue screen (next clue available)
          print("Navigating to next clue #${widget.whichLocation + 2} screen...");
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => ClueScreen(
                allLocations: widget.allLocations, 
                whichLocation: widget.whichLocation + 1, 
                allChallenges: widget.allChallenges, 
                userDetails: widget.userDetails, 
                beginTime: widget.beginTime
              )
            )
          );
        }
        //for last (10th clue)
        else{
          //update db
          addEndTime(widget.userDetails);
          Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.found': true});
          //Nav to Hunt Complete Screen
          print("Navigating to Hunt Complete Screen...");
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => HuntCompleteScreen(
                userDetails: widget.userDetails, 
                allLocations: widget.allLocations, 
                allChallenges: widget.allChallenges
              )
            )
          );
        }
      }
    }); 
  }

  // This function gets lat and long and sets device lat and long
  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {
      myDeviceLat = locationData.latitude;
      myDeviceLong = locationData.longitude;
    });
  }

  // This function is used by the zoomIn map button
  Future<void> zoomIn(double newZoomAmount, double newLat, double newLong) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLat, newLong), 
            zoom: newZoomAmount
          )
        )
      );
      zoomAmount = newZoomAmount;
      screenLat = newLat;
      screenLong = newLong;
    });
  }
  // This function is used by the zoomIn map button
  Future<void> zoomOut(double newZoomAmount, double newLat, double newLong) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLat, newLong), 
            zoom: newZoomAmount
          )
        )
      );
      zoomAmount = newZoomAmount;
      screenLat = newLat;
      screenLong = newLong;
    });
  }

  // This function gets the new lat and long on
  // the map screen after dragging the map
  void _updatePosition(CameraPosition _position) {
    setState(() {
      screenLat = _position.target.latitude;
      screenLong = _position.target.longitude;
    });
  }

  // This functions calculates the distance
  // between two GPS coordinates (Lat, Long)
  double calculateDistance(
    double lat1, double long1, 
    double lat2, double long2
  ) {
    var constR = 6371e3; // metres
    var one = (lat1 * (pi / 180.0));
    var two = (lat2 * (pi / 180.0));
    var three = ((lat2-lat1) * (pi / 180.0));
    var four = ((long2-long1) * (pi / 180.0));

    var a = sin(three/2) * sin(three/2) 
      + cos(one) * cos(two) * sin(four/2) * sin(four/2);
    
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    var d = constR * c;
    
    return d;
  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AppBarTextSpan(context),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              SizedBox(height: screen_height*0.01),
              TextWidget(context, "Congratulations!!", Styles.blackNormalBig, false),
              SizedBox(height: screen_height*0.01),
              TextWidget(context, "You solved the clue.", Styles.blackNormalSmall, true),
              SizedBox(height: screen_height*0.01),
              // If the user has not yet reached/found the clue
              // Display instructions
              widget.allLocations[widget.whichLocation].found == false ?
              TextWidget(context, "Get within 50 meters of", Styles.blackNormalSmall, true)
              : SizedBox(height: 0),
              // Show location to reach
              TextWidget(context, "${widget.allLocations[widget.whichLocation].solution}", Styles.orangeNormalDefault, true),
              SizedBox(height: screen_height*0.01),
              widget.allLocations[widget.whichLocation].found == false ?
              widget.whichLocation == 9 ?
              //for clues 1-9
              TextWidget(context, "to complete your hunt.", Styles.blackNormalSmall, true)
              //for clue 10
              :TextWidget(context, "to unlock the next clue.", Styles.blackNormalSmall, true)
              : SizedBox(height: 0),
              SizedBox(height: screen_height*0.01),
              //This box holds the google maps API
              SizedBox(
                // Expands map container to 35% of screen height, and
                // 90% of screen width
                height: screen_height*0.35, width: screen_width*0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Stack(children: <Widget> [
                        _googleMap(
                          context, _controller, 
                          myMarkers, _updatePosition, 
                          screenLat, screenLong
                        ),
                        _zoomInButton(
                          context, zoomAmount, 
                          zoomIn, screenLat, screenLong
                        ),
                        _zoomOutButton(
                          context, zoomAmount, 
                          zoomOut, screenLat, screenLong
                        ),
                      ]), 
                    ),
                  ),
                )
              ),
              SizedBox(height: screen_height*0.01),
              distanceAway == null ? SizedBox(height:0)
              //If distance away has been calculated
              // display it here
              : TextWidget(
                context, 
                "${distanceAway.toStringAsFixed(distanceAway.truncateToDouble() == distanceAway ? 0 : 0)} meters away", 
                Styles.blackBoldSmall, 
                false
              ),
              Divider(thickness: screen_height*0.005, height: screen_height*0.05, indent: screen_width*0.2, endIndent: screen_width*0.2,),
              
              // If this clue location has already been reached/found
              // Display button to allow user to go to next clue
              widget.allLocations[widget.whichLocation].found == true ? 
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color.fromRGBO(255,117, 26, 1),
                  height: 80, width: 300,
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RaisedButton(
                      color: Colors.black,
                      child: widget.whichLocation < 9 ? 
                      Text('Next Clue',style: Styles.whiteNormalDefault) : Text('Check Progress', style: Styles.whiteNormalDefault),
                      onPressed: (){
                        //for first 9 clues
                        if (widget.whichLocation < 9){
                          print("Navigating to Clue ${widget.whichLocation + 2} Screen...");
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ClueScreen(
                                allLocations: widget.allLocations, 
                                whichLocation: widget.whichLocation + 1, 
                                userDetails: widget.userDetails, 
                                beginTime: widget.beginTime
                              )
                            )
                          );
                        }
                        //last clue, hunt complete
                        else{
                          print("Navigating to Hunt Complete Screen...");
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => HuntCompleteScreen(
                                userDetails: widget.userDetails, 
                                allLocations: widget.allLocations, 
                                allChallenges: widget.allChallenges,
                                whichLocation: widget.whichLocation,
                                beginTime: widget.beginTime,
                              )
                            )
                          );
                        }
                      }
                    ),
                  )
                )
              )
              
              // THIS BUTTON WILL BE REMOVED AFTER TESTING

              : RaisedButton(
                color: Color.fromRGBO(255,117, 26, 1),
                child: Text(
                  "Skip Clue (used for testing)",
                  style: TextStyle(color: Colors.white,),
                ),
                onPressed: (){
                  //mark clueLocation as found
                  widget.allLocations[widget.whichLocation].found = true;
                  
                  //for first 9 clues
                  if (widget.whichLocation < widget.allLocations.length - 1){
                    //update object
                    widget.allLocations[widget.whichLocation + 1].available = true;
                    //update db
                    Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.found': true});
                    Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 2}.available': true});
                    
                    //return to clue screen (next clue available)
                    print("Navigating to Clue Screen...");
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => ClueScreen(
                          allLocations: widget.allLocations, 
                          whichLocation: widget.whichLocation + 1, 
                          allChallenges: widget.allChallenges, 
                          userDetails: widget.userDetails, 
                          beginTime: widget.beginTime
                        )
                      )
                    );
                  }
                  //for last (10th clue)
                  else{
                    addEndTime(widget.userDetails);
                    Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.found': true});
                    //Change to hunt complete screen
                    print("Navigating to Hunt Complete Screen...");
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => HuntCompleteScreen(
                          allLocations: widget.allLocations,
                          whichLocation: widget.whichLocation, 
                          allChallenges: widget.allChallenges,
                          userDetails: widget.userDetails,
                          beginTime: widget.beginTime,
                        )
                      )
                    );
                  }
                }
              ),
              SizedBox(height: screen_height*0.1),
            ]
          )
        )
    );
  }
}

Widget TextWidget(BuildContext context, String text, TextStyle style, bool centered){
  return Text(
    text,
    style: style,
    textAlign: centered == true ? TextAlign.center : TextAlign.left,
  );
}

Widget _googleMap(
  BuildContext context, 
  _controller, myMarkers, 
  void Function(CameraPosition _position) _updatePosition, 
  double screenLat, double screenLong
){
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(screenLat, screenLong),
        zoom: 15,
      ),
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
      },
      markers: myMarkers,
      onCameraMove: ((_position) => _updatePosition(_position)),
    ),
  );
}

Widget _zoomInButton(
  BuildContext context, 
  double zoomAmount, 
  void Function(
    double zoomAmount, 
    double screenLat, 
    double screenLong
  ) zoomIn, 
  double screenLat, double screenLong){
  return Align(
    alignment: Alignment.bottomRight,
    child: RawMaterialButton(
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.orange,
      padding: const EdgeInsets.all(5.0), 
      onPressed: (){
        zoomAmount++;
        zoomIn(zoomAmount, screenLat, screenLong);
      },
      child: Icon(Icons.add),
    )
  );
}

Widget _zoomOutButton(
  BuildContext context, 
  double zoomAmount, 
  void Function(
    double zoomAmount, 
    double screenLat, 
    double screenLong
  ) zoomOut, 
  double screenLat, double screenLong){
  return Align(
    alignment: Alignment.bottomLeft,
    child: RawMaterialButton(
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.orange,
      padding: const EdgeInsets.all(5.0), 
      onPressed: (){
        zoomAmount--;
        zoomOut(zoomAmount, screenLat, screenLong);
      },
      child: Icon(Icons.remove),
    )
  );
}

Widget AppBarTextSpan(BuildContext context){
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'C', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'orrect ', 
          style: Styles.orangeNormalDefault
        ),
        TextSpan(
          text: 'L', 
          style: Styles.whiteBoldDefault
        ),
        TextSpan(
          text: 'ocation', 
          style: Styles.orangeNormalDefault
        ),
      ],
    ),
  );
}

