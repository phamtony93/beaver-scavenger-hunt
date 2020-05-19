// Models
import '../models/provider_details_model.dart';

class UserDetails {
  final String providerDetails;
  final String uid;
  final String userName;
  final String photoUrl;
  final String userEmail;
  String gameCode;
  // final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.uid, this.userName, this.photoUrl, this.userEmail); 
}