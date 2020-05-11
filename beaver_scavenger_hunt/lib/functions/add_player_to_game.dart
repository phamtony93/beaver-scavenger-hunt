import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_details_model.dart';

//adds user's uid to "games" collection in db
  void addPlayerToGame(String gameID, UserDetails userDetails) async {
    Firestore.instance.collection('games').document("$gameID").updateData({'playerIDs': FieldValue.arrayUnion([userDetails.uid])});
  }