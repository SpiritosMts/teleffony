

import 'dart:math';

import 'package:flutter/material.dart';

final myTheme = ThemeData(
  backgroundColor: Colors.white,
  primarySwatch: primaryColorMat,

);
// Define the palette colors
const Color primaryColor = Color(0xFF0097A7);
const Color secondaryColor = Color(0xFFB2EBF2);
const Color accentColor = Color(0xFF006064);

const MaterialColor primaryColorMat = MaterialColor(
  0xFF0097A7,
  <int, Color>{
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF0097A7),
    600: Color(0xFF00838F),
    700: Color(0xFF006064),
    800: Color(0xFF004D40),
    900: Color(0xFF00251A),
  },
);
TextStyle highlightStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.transparent,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.w500,
  shadows: [Shadow(color: Colors.red, offset: Offset(0, -1))],
  decorationColor: Colors.red,
  decorationThickness: 1,
  decorationStyle: TextDecorationStyle.solid,
);
TextStyle bodyStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
);
const mainCol = Color(0xFFffd716);//ylw
const mainCol2 = Color(0xFF16254b);//blue
const buttonStyleCol = Color(0xFFffd716);
const dialogBackgroundColor = Colors.white;


ButtonStyle borderStyle({Color color = primaryColor}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    shape: RoundedRectangleBorder(
        side:  BorderSide(color: color, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(100)),
  );
}
ButtonStyle filledStyle({Color color = primaryColor}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  );
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
Color getRandomColor1() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,

  );
}