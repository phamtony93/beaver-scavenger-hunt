
import '../classes/UserDetails.dart';
import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import '../models/challenge_model.dart';
import 'clue_screen.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_screen.dart';
import 'dart:math';
import 'dart:async';

class CorrectSolutionScreen extends StatefulWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;

  CorrectSolutionScreen({this.allLocations, this.whichLocation, this.allChallenges, this.userDetails});

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

  void updateDeviceLocation() async {
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

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        myDeviceLat = currentLocation.latitude;
        myDeviceLong = currentLocation.longitude;
      });
      //Calculate device's distance from location
      distanceAway = calculateDistance(myDeviceLat, myDeviceLong, widget.allLocations[widget.whichLocation].latitude, widget.allLocations[widget.whichLocation].longitude);
      
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: widget.allLocations, whichLocation: widget.whichLocation + 1, allChallenges: widget.allChallenges, userDetails: widget.userDetails)));
        }
        //for last (10th clue)
        else
         //Change to hunt complete screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen(userDetails: widget.userDetails, allLocations: widget.allLocations, allChallenges: widget.allChallenges)));
      }
    }); 
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {
      myDeviceLat = locationData.latitude;
      myDeviceLong = locationData.longitude;
    });
  }

  Future<void> zoomIn(double newZoomAmount, double newLat, double newLong) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLat, newLong), zoom: newZoomAmount)));
      zoomAmount = newZoomAmount;
      screenLat = newLat;
      screenLong = newLong;
    });
  }

  Future<void> zoomOut(double newZoomAmount, double newLat, double newLong) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLat, newLong), zoom: newZoomAmount)));
      zoomAmount = newZoomAmount;
      screenLat = newLat;
      screenLong = newLong;
    });
  }

  void _updatePosition(CameraPosition _position) {
    setState(() {
      screenLat = _position.target.latitude;
      screenLong = _position.target.longitude;
    });
  }

  double calculateDistance(double lat1, double long1, double lat2, double long2) {
    var constR = 6371e3; // metres
    var one = (lat1 * (pi / 180.0));
    var two = (lat2 * (pi / 180.0));
    var three = ((lat2-lat1) * (pi / 180.0));
    var four = ((long2-long1) * (pi / 180.0));

    var a = sin(three/2) * sin(three/2) + cos(one) * cos(two) * sin(four/2) * sin(four/2);
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
        title: Text(
            "Correct!",
            style: TextStyle(color: Color.fromRGBO(255,117, 26, 1)),
          ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              SizedBox(height: 20),
              Text(
                "Congratulations!!",
                style: TextStyle(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              Text(
                "You solved the clue.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                ),
              widget.allLocations[widget.whichLocation].found == false ? 
              Text(
                "Get within 50 meters of",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                ):
                SizedBox(height: 0),
              Text(
                "${widget.allLocations[widget.whichLocation].solution}",
                style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)),
                textAlign: TextAlign.center,
              ),
              widget.allLocations[widget.whichLocation].found == false ?
              Text(
                "to unlock the next clue.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ):
              SizedBox(height: 0),
              SizedBox(height: 20),
              SizedBox(
                height: screen_height*0.35, width: screen_width*0.9,
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: Stack(children: <Widget> [
                      _googleMap(context, _controller, myMarkers, _updatePosition, screenLat, screenLong),
                      _zoomInButton(context, zoomAmount, zoomIn, screenLat, screenLong),
                      _zoomOutButton(context, zoomAmount, zoomOut, screenLat, screenLong),
                    ]), 
                  ),
                ),
              ),
              distanceAway == null ? SizedBox(height:0):
              Text("${distanceAway.toStringAsFixed(distanceAway.truncateToDouble() == distanceAway ? 0 : 2)} meters away"),
              Divider(thickness: 5, height: 50, indent: 50, endIndent: 50,),
              widget.allLocations[widget.whichLocation].found == true ? RaisedButton(
                color: Color.fromRGBO(255,117, 26, 1),
                child: Text(
                  "Go To Next Clue",
                  style: TextStyle(color: Colors.white,),
                ),
                onPressed: (){
                  if (widget.whichLocation < 9){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: widget.allLocations, whichLocation: widget.whichLocation + 1, userDetails: widget.userDetails,)));
                  }
                }
              ):
              SizedBox(height: 0),
              SizedBox(height: 20),
            ]
          )
        )
    );
  }
}

Widget _googleMap(BuildContext context, _controller, myMarkers, void Function(CameraPosition _position) _updatePosition, double screenLat, double screenLong){
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

Widget _zoomInButton(BuildContext context, double zoomAmount, void Function(double zoomAmount, double screenLat, double screenLong) zoomIn, double screenLat, double screenLong){
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

Widget _zoomOutButton(BuildContext context, double zoomAmount, void Function(double zoomAmount, double screenLat, double screenLong) zoomOut, double screenLat, double screenLong){
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
