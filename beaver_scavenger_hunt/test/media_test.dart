// This is a test package for the ClueLocation Model.

import 'package:flutter_test/flutter_test.dart';
import '../lib/models/media_model.dart';

void main() {
  test('Testing correct ClueLocation model creation', (){

      //create test url string
      String test_url = "test_url";

      //create test_media object from Media model/class
      final test_media = Media();

      //assert null before assigning
      expect(test_media.url, null);
      
      //assert set(function) success
      test_media.setURL(test_url);
      expect(test_media.url, test_url);

      //assert get(function) success
      String test_get_url = test_media.getURL();
      expect(test_get_url, test_url);
  });
}