import 'ProviderDetails.dart';

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl, this.userEmail, this.providerData); 
}