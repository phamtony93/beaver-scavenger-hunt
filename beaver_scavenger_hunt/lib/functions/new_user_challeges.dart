import 'package:cloud_firestore/cloud_firestore.dart';


void uploadNewUserAndChallenges(String uid) {

  Firestore.instance.collection('users').document(uid).setData({
    'userID': uid,
    'challenges': {
      'challengeOne': {
        'Completed': false,
        'Description': 'Read a Book! Photograph the team reading a book in the library',
        'photoUrl': null
      },
      'challengeTwo': {
        'Completed': false,
        'Description': 'Instagram Pic! Take an artsy insta-pic under the Irsih Bend Covered Bridge. Post the pic on social media as well.',
        'photoUrl': null
      },
      'challengeThree': {
        'Completed': false,
        'Description': 'Campus Brochure! Photograph a human pyramid of the team in fron of OSU\'s iconic Weatherford Hall.',
        'photoUrl': null
      },
      'challengeFour': {
        'Completed': false,
        'Description': 'Obstacle Course! Complete the whole USMC obstacle training course. Get video evidence.',
        'photoUrl': null
      },
      'challengeFive': {
        'Completed': false,
        'Description': 'Travel Abroad! Learn a non english greeting from a student at the International Living Learning Center. take a video saying the word.',
        'photoUrl': null
      },
      'challengeSix': {
        'Completed': false,
        'Description': 'Go Greek! Find the most frequent greek letter on Greek row. Take a picture of the letter.',
        'photoUrl': null
      },
      'challengeSeven': {
        'Completed': false,
        'Description': 'Night Life! Photograph the team with an employee at Clodfelters.',
        'photoUrl': null
      },
      'challengeEight': {
        'Completed': false,
        'Description': 'School Spirit! Photograph the team trying something on from the Beaver Store.',
        'photoUrl': null
      },
      'challengeNine': {
        'Completed': false,
        'Description': 'Make a Friend! Video a secret handshake with a stranger.',
        'photoUrl': null
      },
      'challengeTen': {
        'Completed': false,
        'Description': 'Stay Safe! Pick-up a free contraceptive from Student Health Services. Make sure to capture the moment.',
        'photoUrl': null
      },
    }
  });
}