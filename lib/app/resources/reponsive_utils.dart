import 'package:flutter/material.dart';

int _screenHeight = 812;
int _screenWidth = 375;

class UtilsReponsive {
  static double _heightPercent(double inputFigmaSize) {
    return (inputFigmaSize / _screenHeight);
  }

  static double _widthPercent(double inputFigmaSize) {
    return (inputFigmaSize / _screenWidth);
  }

  static double _scaleFactor(BuildContext context, double inputFigmaSize) {
    return MediaQuery.of(context).size.width / _screenWidth;
  }

  static double formatFontSize(double inputFigmaSize, BuildContext context) {
    return inputFigmaSize * _scaleFactor(context, inputFigmaSize);
  }

  static double height( double inputFigmaSize,BuildContext context) {
    return MediaQuery.of(context).size.height * _heightPercent(inputFigmaSize);
  }

  static double width( double inputFigmaSize,BuildContext context) {
    return MediaQuery.of(context).size.width * _widthPercent(inputFigmaSize);
  }

  static double heightWithStatusBar(
      BuildContext context, double inputFigmaSize) {
    var statusbarHeight = MediaQuery.of(context).viewPadding.top;
    var h = height( inputFigmaSize,context) - statusbarHeight;
    if (h < 0) {
      h = 0;
    }
    return h;
  }

  static EdgeInsets padding(BuildContext context,
      {double horizontal = 16, double vertical = 16}) {
    return EdgeInsets.symmetric(
        horizontal: width(horizontal,context ),
        vertical: height(vertical,context));
  }

  static EdgeInsets paddingAll(BuildContext context, {double padding = 16}) {
    return UtilsReponsive.padding(context,
        horizontal: padding, vertical: padding);
  }


}
