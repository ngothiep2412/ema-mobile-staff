import 'package:flutter/material.dart';

class ColorsManager {
  static Color primary = Colors.blue[700]!;
  static const Color mainColor = Color(0xff2da0fa);
  static const Color secondColor = Color(0xff89BFFB);
  static const Color textColor = Color(0xff313131);
  static const Color textColor2 = Color(0xff5e6a81);
  static const Color backgroundWhite = Color(0xffffffff);
  static const Color orange = Color(0xffFE9C5E);
  static const Color textInput = Color(0xFFe7edeb);
  static Color colorIcon = Colors.grey[600]!;
  static Color colorBottomNav = HexColor.fromHex("#A1CFFF");
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
