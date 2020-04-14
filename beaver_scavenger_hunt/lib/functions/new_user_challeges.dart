import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


void uploadNewUserAndChallenges(String uid) async {

  String json = await rootBundle.loadString("assets/clues_and_challenges.json");
  Map jsonMap = jsonDecode(json);
  Firestore.instance.collection('users').document(uid).setData(jsonMap);
  /*
  Firestore.instance.collection('users').document(uid).setData({
    'clue locations': {
      '1': {
        'number': 1,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #1?",
        'solution': "Solution1",
        'solved': false,
        'available': true,
        'photoUrl': null
      },
      '2': {
        'number': 2,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #2?",
        'solution': "Solution2",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '3': {
        'number': 3,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #3?",
        'solution': "Solution3",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '4': {
        'number': 4,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #4?",
        'solution': "Solution4",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '5': {
        'number': 5,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #5?",
        'solution': "Solution5",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '6': {
        'number': 6,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #6?",
        'solution': "Solution6",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '7': {
        'number': 7,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #7?",
        'solution': "Solution7",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '8': {
        'number': 8,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #8?",
        'solution': "Solution8",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '9': {
        'number': 9,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #9?",
        'solution': "Solution9",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
      '10': {
        'number': 10,
        'latitude': 0.00,
        'longitude': 0.00,
        'clue': "Clue #10?",
        'solution': "Solution10",
        'solved': false,
        'available': false,
        'photoUrl': null
      },
    },
    'challenges': {
      '1': {
        'Completed': false,
        'Description': 'Read a Book! Photograph the team reading a book in the library',
        'photoUrl': null
      },
      '2': {
        'Completed': false,
        'Description': 'Instagram Pic! Take an artsy insta-pic under the Irsih Bend Covered Bridge. Post the pic on social media as well.',
        'photoUrl': null
      },
      '3': {
        'Completed': false,
        'Description': 'Campus Brochure! Photograph a human pyramid of the team in fron of OSU\'s iconic Weatherford Hall.',
        'photoUrl': null
      },
      '4': {
        'Completed': false,
        'Description': 'Obstacle Course! Complete the whole USMC obstacle training course. Get video evidence.',
        'photoUrl': null
      },
      '5': {
        'Completed': false,
        'Description': 'Travel Abroad! Learn a non english greeting from a student at the International Living Learning Center. take a video saying the word.',
        'photoUrl': null
      },
      '6': {
        'Completed': false,
        'Description': 'Go Greek! Find the most frequent greek letter on Greek row. Take a picture of the letter.',
        'photoUrl': null
      },
      '7': {
        'Completed': false,
        'Description': 'Night Life! Photograph the team with an employee at Clodfelters.',
        'photoUrl': null
      },
      '8': {
        'Completed': false,
        'Description': 'School Spirit! Photograph the team trying something on from the Beaver Store.',
        'photoUrl': null
      },
      '9': {
        'Completed': false,
        'Description': 'Make a Friend! Video a secret handshake with a stranger.',
        'photoUrl': null
      },
      '10': {
        'Completed': false,
        'Description': 'Stay Safe! Pick-up a free contraceptive from Student Health Services. Make sure to capture the moment.',
        'photoUrl': null
      },
    }
  });
  */
}