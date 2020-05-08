// Packages
import 'package:flutter/material.dart';
// Styles
import '../styles/styles_class.dart';

Widget ControlButton({BuildContext context, String text, String imageLogo, Function onPressFunction}){
  if (imageLogo == null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromRGBO(255,117, 26, 1),
        height: 80, width: 200,
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: RaisedButton(
            color: Colors.black,
            child: Text(
              text,
              style: Styles.whiteNormalSmall
            ),
            onPressed: (){
              onPressFunction(context);
            }
          ),
        )
      )
    );
  } else {
    return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      color: Color.fromRGBO(255,117, 26, 1),
      height: 80, width: 220,
      padding: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: RaisedButton(
          color: Colors.black,
          child: Row(
            children: [
              Image(image: AssetImage(imageLogo), height: 25),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  text,
                  style: Styles.whiteNormalSmall
                ),
              ),
            ],
          ),
          onPressed: (){
            onPressFunction(context);
          }
        ),
      )
    )
    );   
  }
}