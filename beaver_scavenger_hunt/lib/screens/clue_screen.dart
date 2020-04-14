import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import 'correct_solution_screen.dart';
import '../screens/rules_screen.dart';

class ClueScreen extends StatefulWidget {
  
  final List<ClueLocation> allLocations;
  final int whichLocation;
  
  ClueScreen({Key key, this.allLocations, this.whichLocation}) : super(key: key);
  
  @override
  _ClueScreenState createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Clue #${widget.allLocations[widget.whichLocation].number}', style: TextStyle(fontSize: 30, color: Color.fromRGBO(255,117, 26, 1))),
        centerTitle: true,
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          return MenuDrawer(context, widget.allLocations, widget.whichLocation);
        }
      ),
      body: ClueScreenWidget(context, widget.allLocations, formKey, widget.whichLocation, screen_height, screen_width)
    );
  }
}

Widget ClueScreenWidget(BuildContext context, List<ClueLocation> allLocations, formKey, int whichLocation, double screen_height, double screen_width){
  return SingleChildScrollView( 
    child: Column(
      children: <Widget> [ 
        SizedBox(height:screen_height*0.0225),
        ClueContainer(context, '${allLocations[whichLocation].clue}', screen_width, screen_height),
        Divider(thickness: 5, indent: screen_height*0.05, endIndent: screen_height*0.05, height: screen_height*0.05,),
        allLocations[whichLocation].solved == false ?
        GuessForm(context, formKey, allLocations, whichLocation)
        : Text(
          "This clue has been solved",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ]
    ),
  );
}

Widget ClueContainer(BuildContext context, String clue, double screen_width, double screen_height){
  return Center(
    child: SizedBox(
      height: screen_height*0.3,
      width: screen_width*0.95,
      child: Container(
        child: FittedBox(
          child: Text(
            "$clue", 
            textAlign: TextAlign.center,
          )
        )
      )
    )
  );
}

Widget GuessForm(BuildContext context, formKey, List<ClueLocation> allLocations, int whichLocation){
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
          EnterGuessButton(context, "Enter Guess", formKey, allLocations, whichLocation)
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
    onSaved: (value) {
      //
    },
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


Widget EnterGuessButton(BuildContext context, String label, formKey, List<ClueLocation> allLocations, int whichLocation){
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectSolutionScreen(allLocations: allLocations, whichLocation: whichLocation,)));
          }
        },
        splashColor: Color.fromRGBO(255,117, 26, 1),
      ),
    ),
  );
}

Widget MenuDrawer(BuildContext context, List<ClueLocation> allLocations, int which){
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
                MenuClueWidget(context, allLocations, 0, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 1, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 2, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 3, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 4, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 5, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 6, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 7, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 8, scaffoldContext, which),
                MenuClueWidget(context, allLocations, 9, scaffoldContext, which),
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
      title:SizedBox(
        height: 55,
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.black,
          child: Text(
            'Menu', 
            style: TextStyle(color: Colors.white, fontSize: 30,), 
            textAlign: TextAlign.center,
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
    //leading: Icon(),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 30,
          color: Color.fromRGBO(255,117, 26, 1),
          child: FittedBox( 
            child: Text("Rules", style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        ),
    ),
    onTap: () {
      //navigate to rules
      Navigator.push(context, MaterialPageRoute(builder: (context) => RulesScreen()));
    },
  );
}
        
MenuChallengesWidget(BuildContext context){
  return ListTile(
    //leading: Icon(),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 30,
          color: Color.fromRGBO(255,117, 26, 1),
          child: FittedBox( 
            child: Text("Challenges", style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        ),
    ),
    onTap: () {
      //navigate to challenges
    },
  );
}

Widget MenuClueWidget(BuildContext context, List<ClueLocation> allLocations, int which, BuildContext scaffoldContext, int current){
  return ListTile(
    //leading: Icon(),
    title: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 30,
          color: Color.fromRGBO(255,117, 26, 1),
          child: FittedBox( 
            child: Text("Clue${allLocations[which].number}", style: TextStyle(color: allLocations[which].available == true ? Colors.white : Colors.grey, fontSize: 20),),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: which,)));
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