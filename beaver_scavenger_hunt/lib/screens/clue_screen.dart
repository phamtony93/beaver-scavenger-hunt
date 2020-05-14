// Packages
import 'package:beaver_scavenger_hunt/functions/calculate_points.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
// Screens
import 'correct_solution_screen.dart';
import 'profile_screen.dart';
// Models
import '../models/clue_location_model.dart';
import '../models/user_details_model.dart';
import '../models/challenge_model.dart';
// Functions
import '../functions/make_random_dropdown_list.dart';
import '../functions/remove_dropdown_item.dart';
// Widgets
import '../widgets/menu_drawer.dart';
// Styles
import '../styles/styles_class.dart';

class ClueScreen extends StatefulWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final List<Challenge> allChallenges;
  final int whichLocation;
  final beginTime;
  
  // from login screen (if prev user)
  // or welcome screen (if new user)
  ClueScreen({
    Key key, 
    this.allLocations, 
    this.allChallenges, 
    this.whichLocation, 
    this.userDetails, 
    this.beginTime
  }) : super(key: key);
  
  @override
  _ClueScreenState createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {

  final formKey = GlobalKey<FormState>();
  String _myLocation;
  String _myLocationResult;
  bool _incorrect;
  int _guessNumber;
  List<Map> dropdownDataList = [];

  @override
  void initState() {
    super.initState();
    _myLocation = "";
    
    //NEED TO UPDATE TO NEW RULES
    _myLocationResult = 
      "Guess carefully !!" 
      + "\nEach incorrect guess will cost you 5 points";
    _incorrect = false;
    _guessNumber = 0;
    
    // makes randomized list of locations for solution dropdown
    makeRandomDropdownList(widget.allLocations, dropdownDataList);
    //for each clue location
    for (int i = 0; i < 10; i++){
      //if location is already solved
      if (widget.allLocations[i].solved == true){
        //remove it from the list
        removeDropdownItem(widget.allLocations[i].solution, dropdownDataList);
      }
      else{
        break;
      }
    }
  }

  //SET MY STATE FUNCTION
  void setMyState(String value){
    setState(() {
      _myLocation = value;
    });
  }

  //SAVE FORM FUNCTION
  void _saveForm() async {
    var form = formKey.currentState;
    if (_myLocation == ""){
      setState(() {
        _myLocationResult = "Please select a location";
      });
    }
    else if (_myLocation != widget.allLocations[widget.whichLocation].solution) {
      //add incorrectClue to db
      var ds = await Firestore.instance.collection("users").document(widget.userDetails.uid).get();
      int incorrectClues = ds.data['incorrectClues'];
      Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'incorrectClues': incorrectClues + 1});
      
      setState(() {
        _incorrect = true;
        _guessNumber ++;
        _myLocationResult = 
        "Uh oh. Guess number $_guessNumber is incorrect.\n" 
        + "5 points have been deducted from your score.\n\nTry again.";
      });
    }
    // If correct solution is selected
    else if (form.validate()) {
      _incorrect = false;
      form.save();
      // mark clue as solved
      widget.allLocations[widget.whichLocation].solved = true;
      // remove clue from dropdown list
      removeDropdownItem(_myLocation, dropdownDataList);
      
      //for first 9 clues
      //if (widget.whichLocation < 10){
        
        //mark clue as solved in database
        Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.solved': true});
        
        //Navigate to Correct Solution Screen
        // (with allLocations, whichLocation, allChallenges
        // userDetails, and beginTime)
        print("Navigating to Correct Solution Screen...");
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => 
            CorrectSolutionScreen(
            allLocations: widget.allLocations, 
            whichLocation: widget.whichLocation, 
            allChallenges: widget.allChallenges, 
            userDetails: widget.userDetails, 
            beginTime: widget.beginTime
            )
          )
        );
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.osuTheme,
        child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'C', 
                  style: Styles.whiteBoldDefault
                ),
                TextSpan(
                  text: 'lue ', 
                  style: Styles.orangeNormalDefault
                ),
                TextSpan(
                  text: '${widget.allLocations[widget.whichLocation].number}', 
                  style: Styles.whiteBoldDefault
                ),
                TextSpan(
                  text: '/10 ', 
                  style: Styles.orangeNormalDefault
                ),
              ],
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: "Menu",
              );
            },
          ),
          // Profile Icon on right side of appbar
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async { 
                
                var ds = await Firestore.instance.collection("users").document("${widget.userDetails.uid}").get();
                int incorrectClues = ds.data['incorrectClues'];
                int points = calculatePoints(widget.allLocations, widget.allChallenges, incorrectClues);
                
                //Naviage to Profile Screen (with userDetails,
                // allChallenges, allLocations, and beginTime)
                print("Navigating to Profile Screen...");
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                    ProfileScreen(
                    userDetails: widget.userDetails, 
                    allChallenges: widget.allChallenges, 
                    allLocations: widget.allLocations,
                    beginTime: widget.beginTime,
                    points: points,
                    )
                  )
                );
              },
            )
          ],
        ),
        drawer: Builder(
          builder: (BuildContext cntx) {
            //Menu Drawer Widget
            return MenuDrawer(
              context, 
              widget.allLocations, 
              widget.whichLocation, 
              widget.allChallenges, 
              widget.userDetails,
              widget.beginTime
            );
          }
        ),
        body: SingleChildScrollView(
          child: ClueScreenWidget(
            context, widget.allLocations, 
            formKey, widget.whichLocation, 
            widget.userDetails, setMyState, 
            _saveForm, _myLocation, 
            _myLocationResult, _incorrect, 
            dropdownDataList, widget.beginTime,
            widget.allChallenges
          )
        )
      )
    );
  }
}

Widget ClueScreenWidget(
  BuildContext context, 
  List<ClueLocation> allLocations, formKey, 
  int whichLocation,
  UserDetails userDetails, 
  void Function(String) setMyState, void Function() _saveForm, 
  String _myLocation, String _myLocationResult, 
  bool _incorrect, dropdownDataList,
  DateTime beginTime,
  List<Challenge> allChallenges
){
  //get screen height and width
  var screen_width = MediaQuery.of(context).size.width;
  var screen_height = MediaQuery.of(context).size.height;
  return SingleChildScrollView( 
    child: Column(
      children: <Widget> [ 
        SizedBox(height:screen_height*0.0225),
        ClueContainer(
          context, 
          '${allLocations[whichLocation].clue}', 
          screen_width, 
          screen_height
        ),
        //if clue is already solved,
        //show divider and correct solution
        allLocations[whichLocation].solved == true ?
        Divider(
          thickness: 5, 
          indent: screen_height*0.05, 
          endIndent: screen_height*0.05, 
          height: screen_height*0.05
        )
        : SizedBox(height: 0),
        allLocations[whichLocation].solved == true ?
        Center(
          child: Text(
            "${allLocations[whichLocation].solution}",
            style: Styles.orangeBoldDefault,
            textAlign: TextAlign.center,
          ),
        ):
        SizedBox(height: 0),
        Divider(
          thickness: 5, 
          indent: screen_height*0.05, 
          endIndent: screen_height*0.05, 
          height: screen_height*0.05
        ),
        
        //if clue is not yet solved,
        //show dropdown
        allLocations[whichLocation].solved == false ?
        //DROPDOWNFORM CURRENTLY IN USE (COMMENT OUT LINE BELOW TO USE GUESSFORM)
        DropdownForm(
          context, formKey, 
          setMyState, _saveForm, 
          _myLocation, _myLocationResult, 
          _incorrect, allLocations, 
          dropdownDataList
        )
        //GUESSFORM CURRENTLY NOT IN USE (UNCOMMENT THIS LINE AND WIDGETS BELOW TO USE)
        //GuessForm(context, formKey, allLocations, whichLocation, userDetails)
        : Text(
          "This clue has been solved",
          style: Styles.blackNormalDefault,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 100),
        
        //if clue is not yet solved,
        //show go to map button
        allLocations[whichLocation].solved == true ?
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
                child: Text(
                  'Go To Map',
                  style: Styles.whiteNormalDefault
                ),
                onPressed: (){
                  //Navigate to Correct Solution Screen
                  // (with allLocations, whichLocation, userDetails
                  // allChallenges, and beginTime)
                  print("Navigating to Correct Solution Screen...");
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => 
                      CorrectSolutionScreen(
                        allLocations: allLocations, 
                        whichLocation: whichLocation, 
                        userDetails: userDetails,
                        allChallenges: allChallenges,
                        beginTime: beginTime,
                      )
                    )
                  );
                }
              ),
            )
          )
        )
        : SizedBox(height: 0)
      ]
    ),
  );
}

Widget ClueContainer(
  BuildContext context, 
  String clue, 
  double screen_width, double screen_height
){
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:SizedBox(
        height: screen_height*0.3,
        width: screen_width*0.95,
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(child: 
              Wrap(children: <Widget> [
                Text(
                  "$clue", 
                  style: Styles.whiteNormalDefault,
                  textAlign: TextAlign.center,
                )
              ])
            )
          )
        )
      )
    )
  );
}

//CURRENTLY IN USE (COMMENT OUT WHEN NOT IN USE)

Widget DropdownForm(
  BuildContext context, formKey, 
  void Function(String) setMyState, 
  void Function() _saveForm, String _myLocation, 
  String _myLocationResult, bool _incorrect, 
  List<ClueLocation> allLocations, dropdownDataList
){
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: DropDownFormField(
                required: true,
                errorText: "Please select a location",
                titleText: 'Location',
                hintText: 'Please select one',
                value: _myLocation,
                onSaved: (value) {
                  setMyState(value);
                },
                onChanged: (value) {
                  setMyState(value);
                },
                dataSource: dropdownDataList,
                textField: 'display',
                valueField: 'value',
              ),
            ),
            Container(
              height: 110,
              padding: EdgeInsets.all(16),
              child: Text(
                _myLocationResult,
                style: TextStyle(
                  color: _incorrect == false ? 
                  Colors.black : Colors.red
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
                    child: Text(
                      'Enter Guess',
                      style: Styles.whiteNormalDefault
                    ),
                    onPressed: _saveForm
                  ),
                )
              )
            )
          ],
        )
      )
    )
  );
}

//CURRENTLY NOT IT USE (UNCOMMENT TO USE)

/*
Widget GuessForm(BuildContext context, formKey, List<ClueLocation> allLocations, int whichLocation, UserDetails userDetails){
  return Padding(
    padding: EdgeInsets.all(10),
    child: Form( 
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GuessInputBox(context, allLocations, whichLocation),
          SizedBox(height: 10),
          Text(
            "Guess carefully.\n"
          +"Each incorrect guess will add 5 minutes to your overall time.",
            textAlign: TextAlign.center
          ),
          Divider(height: 30, thickness: 5, indent: 25, endIndent: 25,),
          EnterGuessButton(context, "Enter Guess", formKey, allLocations, whichLocation, userDetails)
        ]
      )
    )
  );
}

Widget GuessInputBox(BuildContext context, List<ClueLocation> allLocations, int whichLocation){
  return TextFormField(
    autofocus: true,
    style: TextStyle(fontSize: 20),
    decoration: InputDecoration(
      hintText: 'Guess the next location',
      labelText: 'Location', 
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
    ),
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter a guess';
      }
      else if(value != allLocations[whichLocation].solution){
        return 'Incorrect. Try again';
      }
      else {
        return null;
      }
    },
  );
}


Widget EnterGuessButton(BuildContext context, String label, formKey, List<ClueLocation> allLocations, int whichLocation, UserDetails userDetails){
  return SizedBox(
    height: 80,
    width: 200,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: RaisedButton(
        color: Colors.black,
        child: Text(
          label,
          style: TextStyle(color: Color.fromRGBO(255,117, 26, 1), fontSize: 25),
          textAlign: TextAlign.center,
          ),
        onPressed: () async {
          if (formKey.currentState.validate()){
            formKey.currentState.save();
            //still need to push this change to database
            allLocations[whichLocation].solved = true;
            Firestore.instance.collection("users").document(userDetails.uid).updateData({'clue locations.${whichLocation + 1}.solved': true});
            Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectSolutionScreen(allLocations: allLocations, whichLocation: whichLocation, userDetails: userDetails)));
          }
        },
        splashColor: Color.fromRGBO(255,117, 26, 1),
      ),
    ),
  );
}
*/