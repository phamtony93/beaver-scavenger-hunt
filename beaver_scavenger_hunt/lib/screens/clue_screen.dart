import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import 'correct_solution_screen.dart';
import '../screens/challenge_screen.dart';
import '../screens/rules_screen.dart';
import '../classes/UserDetails.dart';
import '../functions/make_random_dropdown_list.dart';
import '../functions/remove_dropdown_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class ClueScreen extends StatefulWidget {
  
  UserDetails userDetails;
  final List<ClueLocation> allLocations;
  final int whichLocation;
  
  ClueScreen({Key key, this.allLocations, this.whichLocation, this.userDetails}) : super(key: key);
  
  @override
  _ClueScreenState createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {

  final formKey = GlobalKey<FormState>();
  //String dropdownValue = "Select a location";
  String _myLocation;
  String _myLocationResult;
  bool _incorrect;
  int _guessNumber;
  List<Map> dropdownDataList = [];

  @override
  void initState() {
    super.initState();
    _myLocation = "";
    _myLocationResult = "Guess carefully !!\nEach incorrect guess will add 5 minutes\nto your hunt timer";
    _incorrect = false;
    _guessNumber = 0;
    
    makeRandomDropdownList(widget.allLocations, dropdownDataList);

    for (int i = 0; i < 10; i++){
      if (widget.allLocations[i].solved == true){
        removeDropdownItem(widget.allLocations[i].solution, dropdownDataList);
      }
      else{
        break;
      }
    }

  }

  void setMyState(String value){
    setState(() {
      _myLocation = value;
    });
  }

  void _saveForm() {
    var form = formKey.currentState;
    if (_myLocation == ""){
      setState(() {
        _myLocationResult = "Please select a location";
      });
    }
    else if (_myLocation != widget.allLocations[widget.whichLocation].solution) {
      setState(() {
        _incorrect = true;
        _guessNumber ++;
        _myLocationResult = "Uh oh. Guess number $_guessNumber is incorrect.\n5 minutes have been added to your timer.\n\nTry again.";
      });
    }
    else if (form.validate()) {
      _incorrect = false;
      form.save();
      widget.allLocations[widget.whichLocation].solved = true;
      removeDropdownItem(_myLocation, dropdownDataList);
      Firestore.instance.collection("users").document(widget.userDetails.uid).updateData({'clue locations.${widget.whichLocation + 1}.solved': true});
      Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectSolutionScreen(allLocations: widget.allLocations, whichLocation: widget.whichLocation, userDetails: widget.userDetails)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: 'C', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              TextSpan(text: 'lue ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
              TextSpan(text: '${widget.allLocations[widget.whichLocation].number}', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              TextSpan(text: '/10 ', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
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
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          return MenuDrawer(context, widget.allLocations, widget.whichLocation, widget.userDetails);
        }
      ),
      body: SingleChildScrollView(
        child: ClueScreenWidget(context, widget.allLocations, formKey, widget.whichLocation, screen_height, screen_width, widget.userDetails, setMyState, _saveForm, _myLocation, _myLocationResult, _incorrect, dropdownDataList)
      )
    );
  }
}

Widget ClueScreenWidget(BuildContext context, List<ClueLocation> allLocations, formKey, int whichLocation, double screen_height, double screen_width, UserDetails userDetails, void Function(String) setMyState, void Function() _saveForm, String _myLocation, String _myLocationResult, bool _incorrect, dropdownDataList){
  return SingleChildScrollView( 
    child: Column(
      children: <Widget> [ 
        SizedBox(height:screen_height*0.0225),
        ClueContainer(context, '${allLocations[whichLocation].clue}', screen_width, screen_height),
        allLocations[whichLocation].solved == true ?
        Divider(thickness: 5, indent: screen_height*0.05, endIndent: screen_height*0.05, height: screen_height*0.05,)
        : SizedBox(height: 0),
        allLocations[whichLocation].solved == false ? 
        SizedBox(height: 0) :
        Center(
          child: Text(
            "${allLocations[whichLocation].solution}",
            style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1), fontWeight: FontWeight.bold),
          ),
        ),
        Divider(thickness: 5, indent: screen_height*0.05, endIndent: screen_height*0.05, height: screen_height*0.05,),
        allLocations[whichLocation].solved == false ?
        //DROPDOWNFORM CURRENTLY IN USE (COMMENT OUT LINE BELOW TO USE GUESSFORM)
        DropdownForm(context, formKey, setMyState, _saveForm, _myLocation, _myLocationResult, _incorrect, allLocations, dropdownDataList)
        //GUESSFORM CURRENTLY NOT IN USE (UNCOMMENT THIS LINE AND WIDGETS BELOW TO USE)
        //GuessForm(context, formKey, allLocations, whichLocation, userDetails)
        : Text(
          "This clue has been solved",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        allLocations[whichLocation].solved == true ?
        RaisedButton(
          child: Text("Go To Map"),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectSolutionScreen(allLocations: allLocations, whichLocation: whichLocation, userDetails: userDetails)));
          }
        ) 
        : SizedBox(height: 0)
      ]
    ),
  );
}

Widget ClueContainer(BuildContext context, String clue, double screen_width, double screen_height){
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
                  style: TextStyle(fontSize: 30, color: Colors.white),
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

Widget DropdownForm(BuildContext context, formKey, void Function(String) setMyState, void Function() _saveForm, String _myLocation, String _myLocationResult, bool _incorrect, List<ClueLocation> allLocations, dropdownDataList){
  return Center(
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
              style: TextStyle(color: _incorrect == false ? Colors.black : Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            color: Color.fromRGBO(255,117, 26, 1),
            height: 100, width: 300,
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              color: Colors.black,
              child: Text(
                'Enter Guess',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              onPressed: _saveForm
            ),
          )
        ],
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

Widget MenuDrawer(BuildContext context, List<ClueLocation> allLocations, int which, UserDetails userDetails){
  return GestureDetector(
    onTap: (){
      Navigator.pop(context);
    },
    child:Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 25),
                MyDrawerHeader(context),
                MenuRulesWidget(context),
                MenuChallengesWidget(context),
                MenuClueWidget(context, allLocations, 0, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 1, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 2, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 3, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 4, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 5, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 6, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 7, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 8, scaffoldContext, which, userDetails),
                MenuClueWidget(context, allLocations, 9, scaffoldContext, which, userDetails),
              ],
            )
          );
        }
      )
    )
  );
}

Widget MyDrawerHeader(BuildContext context){
  return ListTile(
      title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 55,
          child: Container(
            padding: EdgeInsets.all(5),
            color: Colors.black,
            child: FittedBox(
              child:Text(
                'Menu', 
                style: TextStyle(color: Colors.white), 
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
  );
}

MenuRulesWidget(BuildContext context){
  return ListTile(
    leading: Icon(Icons.list, color: Colors.black),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: FittedBox( 
              child: Text("Rules", style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
    ),
    onTap: () {
      //navigate to rules
      Navigator.popAndPushNamed(context, '/rules_screen');
    },
  );
}
        
MenuChallengesWidget(BuildContext context){
  return ListTile(
    leading: Icon(Icons.directions_run, color: Colors.black),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child:FittedBox( 
              child: Text("Challenges", style: TextStyle(color: Colors.white)),
            ),
          ),
        )
    ),
    onTap: () {
      Navigator.popAndPushNamed(context, '/challenge_screen');
    },
  );
}

Widget MenuClueWidget(BuildContext context, List<ClueLocation> allLocations, int which, BuildContext scaffoldContext, int current, UserDetails userDetails){
  return ListTile(
    leading: Icon(allLocations[which].solved == true ? Icons.check: Icons.lightbulb_outline, color: allLocations[which].available == true ? Colors.black: Colors.grey),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 35,
          color: Color.fromRGBO(255,117, 26, 1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child:FittedBox( 
              child: Text("Clue ${allLocations[which].number}", style: TextStyle(color: allLocations[which].available == true ? Colors.white : Colors.grey),),
            ),
          ),
        ),
    ),
    onTap: () {
      //navigate to clue
      if (allLocations[which].available == true) {
        if (which == current){
          Navigator.pop(context);
        }
        else{
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: which, userDetails: userDetails,)));
        }
      }
      else{
        final snackBar = SnackBar(
          content: Text(
            "This clue is not yet available",
            textAlign: TextAlign.center
          )
        );
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
      }
    },
  );
}