//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// Models
import '../models/user_details_model.dart';

void uploadNewAdmin(UserDetails userDetails, String gameCode) async {
  await Firestore.instance.collection('admins').document(userDetails.uid).setData({'gameID': gameCode});
  await Firestore.instance.collection('games').document(gameCode).setData({'open': true});
}
