import 'package:flutter/material.dart';
import '../models/clue_location_model.dart';
import 'correct_solution_screen.dart';

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
    final screen_width = MediaQuery.of(context).size.width;
    final screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Clue #${widget.allLocations[widget.whichLocation].number}', style: TextStyle(fontSize: 30),),
        centerTitle: true,
      ),
      drawer: Builder(
        builder: (BuildContext cntx) {
          return MenuDrawer(context, widget.allLocations, widget.whichLocation);
        }
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: <Widget> [ 
            SizedBox(height:screen_height*0.0225),
            ClueContainer(context, '${widget.allLocations[widget.whichLocation].clue}', screen_width, screen_height),
            Divider(thickness: 5, indent: screen_height*0.05, endIndent: screen_height*0.05, height: screen_height*0.05,),
            widget.allLocations[widget.whichLocation].solved == false ?
            GuessForm(context, formKey, widget.allLocations, widget.whichLocation)
            : Text(
              "This clue has been solved",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ]
        ),
      ),
    );
  }
}

Widget ClueContainer(BuildContext context, String clue, double screen_width, double screen_height){
  return Center(
    child: SizedBox(
      height: screen_height*0.3,
      width: screen_width*0.95,
      child: Container(
        color: Colors.grey,
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
          //GuessInputBox(context, allLocations, whichLocation),
          Text(
            "Guess carefully.\n"
          +"Each incorrect guess will add 5 minutes to your overall time.",
            textAlign: TextAlign.center
          ),
          Divider(height: 30, thickness: 5,),
          EnterGuessButton(context, "Enter Guess", formKey, allLocations, whichLocation)
        ]
      )
    ),
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
        child: Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 25),
          textAlign: TextAlign.center,
          ),
        onPressed: () async {
          if (formKey.currentState.validate()){
            formKey.currentState.save();
            allLocations[whichLocation].solved = true;
            Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectSolutionScreen(allLocations: allLocations, whichLocation: whichLocation,)));
          }
        },
        splashColor: Colors.blue,
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
          color: Colors.orange,
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
          color: Colors.deepOrange,
          child: FittedBox( 
            child: Text("Rules", style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        ),
    ),
    onTap: () {
      //navigate to rules
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
          color: Colors.deepOrange,
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
          color: Colors.deepOrange,
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