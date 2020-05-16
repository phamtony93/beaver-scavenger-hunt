// Packages
import 'package:flutter/material.dart';

class Styles {
  static final String _defaultText = 'OpenSans';
  static const _textSizeExtraLarge = 36.0;
  static const _textSizeLarge = 22.0;
  static const _textSizeMedium = 20.0;
  static const _textSizeDefault = 16.0;
  static const _textSizeSmall = 14.0;

  static final titles = TextStyle (
    fontSize: _textSizeLarge,
    fontFamily: _defaultText,
    fontWeight: FontWeight.w800
  );

  static final bodyText = TextStyle(
    fontSize: _textSizeDefault,
    fontFamily: _defaultText
  );

  static final bold = TextStyle(
    fontFamily: _defaultText,
    fontWeight: FontWeight.w800,
    fontSize: _textSizeMedium,
  );

  static const defaultFontSize = 30.0;

  static final orangeNormalDefault = TextStyle(
    color: osuOrange,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: defaultFontSize
  );

  static final orangeNormalSmall = TextStyle(
    color: osuOrange,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: 20
  );

  static final orangeBoldDefault = TextStyle(
    color: osuOrange,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: defaultFontSize
  );

  static final orangeBoldSmall = TextStyle(
    color: osuOrange,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );

  static final whiteNormalDefault = TextStyle(
    color: osuWhite,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: defaultFontSize
  );

  static final whiteNormalSmall = TextStyle(
    color: osuWhite,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: 20
  );
  
  static final whiteBoldDefault = TextStyle(
    color: osuWhite,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: defaultFontSize
  );

  static final whiteBoldSmall = TextStyle(
    color: osuWhite,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );

  static final blackBoldDefault = TextStyle(
    color: osuBlack,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: defaultFontSize
  );

  static final blackBoldSmall = TextStyle(
    color: osuBlack,
    fontFamily: _defaultText,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );
  
  static final blackNormalDefault = TextStyle(
    color: osuBlack,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: defaultFontSize
  );

  static final blackNormalSmall = TextStyle(
    color: osuBlack,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: 20
  );

  static final blackNormalBig = TextStyle(
    color: osuBlack,
    fontFamily: _defaultText,
    fontWeight: FontWeight.normal,
    fontSize: 50
  );


  static final Color osuBlack = Colors.black;
  static final Color osuWhite = Colors.white;
  static final Color osuOrange = Color.fromRGBO(255,117, 26, 1);

  static final osuTheme = ThemeData(
    primaryColor: osuBlack,
    accentColor: osuOrange, 
    fontFamily: 'OpenSans',
    textTheme: TextTheme(
      headline: TextStyle(
        color: osuWhite,
        fontSize: defaultFontSize,
        fontWeight: FontWeight.bold
      ),
      title: titles,
      body1: bodyText, 
    )
    );


}