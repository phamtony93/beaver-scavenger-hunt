
import '../classes/UserDetails.dart';
import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
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
  final int whichLocation;

  CorrectSolutionScreen({this.allLocations, this.whichLocation, this.userDetails});

  @override
  _CorrectSolutionScreenState createState() => _CorrectSolutionScreenState();
}

class _CorrectSolutionScreenState extends State<CorrectSolutionScreen> {

  Completer<GoogleMapController> _controller = Completer();
  LocationData locationData;
  double distanceAway;
  CameraPosition currentPosition;
  double zoomAmount;
  Set<Marker> myMarkers = {};
  
  void initState(){
    super.initState();
    retrieveLocation();
    zoomAmount = 15;
    currentPosition = CameraPosition(
      target: LatLng(44.562854, -123.278977),
      zoom: 15,
    );
    
    Marker OSU = Marker(
      markerId: MarkerId("${widget.allLocations[widget.whichLocation].solution}"),
      position: LatLng(widget.allLocations[widget.whichLocation].latitude, widget.allLocations[widget.whichLocation].longitude),
      infoWindow: InfoWindow(title: "${widget.allLocations[widget.whichLocation].solution}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
    );

    myMarkers.add(OSU);
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    //distanceAway = calculateDistance(locationData.latitude, widget.allLocations[widget.whichLocation].latitude);
    setState(() {
    
    });
  }

  Future<void> zoomIn(double newZoomAmount) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(44.562854, -123.278977), zoom: newZoomAmount)));
      zoomAmount = newZoomAmount;
    });
  }

  Future<void> zoomOut(double newZoomAmount) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(44.562854, -123.278977), zoom: newZoomAmount)));
      zoomAmount = newZoomAmount;
    });
  }

  double calculateDistance(double deviceLocation, double clueLocation) {
    double distanceAway;

    return distanceAway;
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
                "You found the correct location. Head to",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                ),
              Text(
                "${widget.allLocations[widget.whichLocation].solution}",
                style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1)),
                textAlign: TextAlign.center,
              ),
              Text(
                "to unlock the next clue.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: screen_height*0.35, width: screen_width*0.9,
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: Stack(children: <Widget> [
                      _googleMap(context, _controller, myMarkers),
                      _zoomInButton(context, zoomAmount, zoomIn),
                      _zoomOutButton(context, zoomAmount, zoomOut),
                    ]), 
                  ),
                ),
              ),
              Divider(thickness: 5, height: 50, indent: 50, endIndent: 50,),
              RaisedButton(
                color: Color.fromRGBO(255,117, 26, 1),
                child: Text(
                  "Check Location",
                  style: TextStyle(color: Colors.white,),
                ),
                onPressed: (){
                  if (widget.whichLocation < 9){
                    //update object
                    widget.allLocations[widget.whichLocation + 1].available = true;
                    //update db
                    Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 2}.available': true});
                    //return to clue screen (next clue available)
                  
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: widget.allLocations, whichLocation: widget.whichLocation + 1, userDetails: widget.userDetails,)));
                  }
                  else{
                    //Change to hunt complete screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                  }
                }
              ),
              SizedBox(height: 20),
            ]
          )
        )
    );
  }
}

Widget _googleMap(BuildContext context, _controller, myMarkers){
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(44.562854, -123.278977),
        zoom: 15,
      ),
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
      },
      markers: myMarkers
    ),
  );
}

Widget _zoomInButton(BuildContext context, double zoomAmount, void Function(double zoomAmount) zoomIn){
  return Align(
    alignment: Alignment.bottomRight,
    child: RawMaterialButton(
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.orange,
      padding: const EdgeInsets.all(5.0), 
      onPressed: (){
        zoomAmount++;
        zoomIn(zoomAmount);
      },
      child: Icon(Icons.add),
    )
  );
}

Widget _zoomOutButton(BuildContext context, double zoomAmount, void Function(double zoomAmount) zoomOut){
  return Align(
    alignment: Alignment.bottomLeft,
    child: RawMaterialButton(
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.orange,
      padding: const EdgeInsets.all(5.0), 
      onPressed: (){
        zoomAmount--;
        zoomOut(zoomAmount);
      },
      child: Icon(Icons.remove),
    )
  );
}

