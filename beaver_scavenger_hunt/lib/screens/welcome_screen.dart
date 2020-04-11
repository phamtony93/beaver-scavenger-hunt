import 'package:flutter/material.dart';
import 'package:beaver_scavenger_hunt/classes/UserDetails.dart';
import 'clue_screen.dart';
import '../models/clue_location_model.dart';
import 'rules_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final UserDetails userDetails;

  WelcomeScreen({this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),  //Replace with 'Welcome' and create profile button
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 275,
              width: 275,
              image: AssetImage('assets/images/osu_logo.png'),
              fit: BoxFit.fill,
            ),
            Text('Scavenger', style: TextStyle(fontSize: 60)),
            Text('Hunt', style: TextStyle(fontSize: 60)),
            SizedBox(
               height: 50,
            ),
            RaisedButton(
              child: Text('Hunt Rules'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RulesScreen())
                );
              }
            ),
            RaisedButton(
              child: Text('Begin Hunt'),
              onPressed: (){
                print('Begin!');

                List<ClueLocation> allLocations = [];
                ClueLocation loca1 = ClueLocation(1, 1.1, -1.1, "Clue #1?", "Solution1");
                loca1.available = true;
                ClueLocation loca2 = ClueLocation(2, 2.2, -2.2, "Clue #2?", "Solution2");
                ClueLocation loca3 = ClueLocation(3, 3.5, -3.3, "Clue #3?", "Solution3");
                ClueLocation loca4 = ClueLocation(4, 4.5, -4.4, "Clue #4?", "Solution4");
                ClueLocation loca5 = ClueLocation(5, 5.5, -5.5, "Clue #5?", "Solution5");
                ClueLocation loca6 = ClueLocation(6, 6.5, -6.6, "Clue #6?", "Solution6");
                ClueLocation loca7 = ClueLocation(7, 7.5, -7.7, "Clue #7?", "Solution7");
                ClueLocation loca8 = ClueLocation(8, 18.5, -8.8, "Clue #8?", "Solution8");
                ClueLocation loca9 = ClueLocation(9, 9.5, -9.9, "Clue #9?", "Solution9");
                ClueLocation loca10 = ClueLocation(10, 10.10, -10.10, "Clue #10?", "Solution10");
                allLocations.add(loca1);
                allLocations.add(loca2);
                allLocations.add(loca3);
                allLocations.add(loca4);
                allLocations.add(loca5);
                allLocations.add(loca6);
                allLocations.add(loca7);
                allLocations.add(loca8);
                allLocations.add(loca9);
                allLocations.add(loca10);

                Navigator.push(context, MaterialPageRoute(builder: (context) => ClueScreen(allLocations: allLocations, whichLocation: 0,)));

              }
            ),
          ]
        )
      )
    );
  }
}
