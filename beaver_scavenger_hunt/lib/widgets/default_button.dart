import 'package:flutter/material.dart';
import '../styles/styles_class.dart';

Widget DefaultButton(BuildContext context, text){
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
            text,
            style: Styles.whiteBoldDefault
          ),
          onPressed: (){
            //onPressed function goes here
          }
        ),
      )
    )
  );
}