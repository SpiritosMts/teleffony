

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teleffony/homeScreen_ctr.dart';
import 'package:teleffony/manager/tutoCtr.dart';

class GetxBinding implements Bindings {
  @override
  void dependencies() {


    //tuto
    Get.lazyPut<TutoController>(() => TutoController(),fenix: true);
    Get.lazyPut<HomeCtr>(() => HomeCtr(),fenix: true);


    //print("## getx dependency injection completed (Get.put() )");

  }
}