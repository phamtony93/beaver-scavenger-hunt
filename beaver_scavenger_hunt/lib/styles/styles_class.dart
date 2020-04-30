import 'package:flutter/material.dart';

class Styles {
  static final String _defaultText = 'OpenSans';
  static const _textSizeExtraLarge = 36.0;
  static const _textSizeLarge = 22.0;
  static const _textSizeMedium = 20.0;
  static const _textSizeDefault = 16.0;
  static const _textSizeSmall = 14.0;

  static final Color _textColorDefault = Colors.black;
  static final Color _textColorWhite = Colors.white;

  // static final bubbles = TextStyle (
  //   fontSize: _textSizeMedium,
  //   color: _textColorWhite,
  //   fontFamily: _defaultText,
  //   fontWeight: FontWeight.w800
  // );

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


}