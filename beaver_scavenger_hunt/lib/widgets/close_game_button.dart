// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Models
import '../models/user_details_model.dart';
// Functions
import '../functions/check_game_is_active.dart';
// Styles
import '../styles/styles_class.dart';

Widget CloseGameButton(BuildContext context, String gameCode, UserDetails user){
  return ClipRRect(
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
            "Close Game",
            style: Styles.whiteNormalDefault
          ),
          onPressed: () async {
            bool gameIsActive = await checkAdminGameIsActive(user);
            if (gameIsActive == false) {
              final snackBar = SnackBar(
                content: Text('Game has already ended.', textAlign: TextAlign.center,)
              );
              Scaffold.of(context).showSnackBar(snackBar);
            } else {
              //mark game as closed
              print("Closing game: $gameCode");
              final snackBar = SnackBar(
                content: Text('Game: $gameCode closed', textAlign: TextAlign.center,)
              );
              Scaffold.of(context).showSnackBar(snackBar);
              Firestore.instance.collection('games').document(gameCode).updateData({'open': false});
            }
          }
        ),
      )
    )
  );
}