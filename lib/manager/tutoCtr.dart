import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:teleffony/main.dart';

class TutoController extends GetxController {

  /// this is for coach tuto

 bool showAllTuto = false; //TODO "true" before release
double opacityShadow =.8;
//Color colorShadow = Color(0XFFe9dda9);
Color colorShadow = Colors.red;
TextStyle tutoTextStyle = const TextStyle(
    color: Colors.white,
    height: 1.5,
  fontWeight: FontWeight.w500
);
bool hideSkip = true;
AlignmentGeometry alignSkip = Alignment.topCenter;
  @override
  void onInit() {
    //print('## onInit TutoController');
  }





}
