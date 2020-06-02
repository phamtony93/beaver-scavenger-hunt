import 'package:flutter_test/flutter_test.dart';
import '../lib/functions/remove_dropdown_item.dart';

void main() async{
    
  test('Testing remove_dropdown_item function', (){
      //create test vars
      String item = "test_item_to_remove";
      List<Map> dropdownDataList = [
        {
          "value": 1,
          "display": "do not remove"
        },
        {
          "value": 2,
          "display": "do not remove"
        },
        {
          "value": 3,
          "display": "do not remove"
        },
        {
          "value": 4,
          "display": "test_item_to_remove"
        },
        {
          "value": 5,
          "display": "do not remove"
        }
      ];

      //run function
      removeDropdownItem(item, dropdownDataList);
      
      //assert expected results
      
      //assert size is 4
      expect(dropdownDataList.length, 4);
      //assert correct list items remain
      expect(dropdownDataList[0]["value"], 1);
      expect(dropdownDataList[1]["value"], 2);
      expect(dropdownDataList[2]["value"], 3);
      expect(dropdownDataList[3]["value"], 5);
  });
}