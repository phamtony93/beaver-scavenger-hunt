
import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import 'clue_screen.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class CorrectSolutionScreen extends StatefulWidget {
  
  final List<ClueLocation> allLocations;
  final int whichLocation;

  CorrectSolutionScreen({this.allLocations, this.whichLocation});

  @override
  _CorrectSolutionScreenState createState() => _CorrectSolutionScreenState();
}

class _CorrectSolutionScreenState extends State<CorrectSolutionScreen> {

  GoogleMapController _controller;
  LocationData locationData;
  double distanceAway;
  
  void initState(){
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    //distanceAway = calculateDistance(locationData.latitude, widget.allLocations[widget.whichLocation].latitude);
    setState(() {
    
    });
  }

  static final CameraPosition _kOSU = CameraPosition(
    target: LatLng(44.562854, -123.278977),
    zoom: 15,
  );

  double calculateDistance(double deviceLocation, double clueLocation) {
    double distanceAway;

    return distanceAway;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Container(),
        title: Text("Correct!"),
        centerTitle: true,
      ),
      body: Column(
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
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              "to unlock the next clue.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300, width: 400,
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: 
                  
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kOSU,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ),
              ),
            ),
            Divider(thickness: 5, height: 10, indent: 50, endIndent: 50,),
            RaisedButton(
              child: Text("Check Location"),
              onPressed: (){
                widget.allLocations[widget.whichLocation + 1].available = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: widget.allLocations, whichLocation: widget.whichLocation + 1,)));
              }
            )
          ]
        )
    );
  }
}
