import 'package:flutter/material.dart';

class ColorsManager {
  static Color primary = Colors.blue.withOpacity(0.8);
  static const Color mainColor = Color(0xff2da0fa);
  static const Color secondColor = Color(0xff89BFFB);
  static const Color textColor = Color(0xff313131);
  static const Color textColor2 = Color(0xff5e6a81);
  static const Color backgroundWhite = Color(0xffffffff);
  static Color orange = const Color(0xffFE9C5E).withOpacity(0.8);
  static const Color textInput = Color(0xFFe7edeb);
  static Color colorIcon = Colors.grey[600]!;
  static Color colorBottomNav = HexColor.fromHex("#A1CFFF");
  static const Color backgroundGrey = Color(0xffF1F1F0);
  static const Color backgroundBlackGrey = Color(0xff232533);
  static const Color backgroundContainer = Color(0xffF4F5F7);
  static const Color calendar = Color(0xffC2B280);

  static Color green = const Color(0xff198754).withOpacity(0.8);
  static Color red = const Color(0xffdc3545).withOpacity(0.8);
  static Color yellow = const Color(0xffffc107).withOpacity(0.8);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
