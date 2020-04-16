removeDropdownItem(String item, dropdownDataList){
    for (int i = 0; i < dropdownDataList.length; i++){
      if (dropdownDataList[i]["display"] == item){
        dropdownDataList.removeAt(i);
      }
    }
  }