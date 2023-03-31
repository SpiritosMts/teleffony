

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';
import 'styles.dart';

Future<bool> showNoHeader({String? txt,String? btnOkText='delete',Color btnOkColor=Colors.red,IconData? icon=Icons.delete}) async {
  bool shouldDelete = false;

  await AwesomeDialog(
    context: navigatorKey.currentContext!,
    dialogBackgroundColor: dialogBackgroundColor,
    autoDismiss: true,
    isDense: true,
    dismissOnTouchOutside: true,
    showCloseIcon: false,
    headerAnimationLoop: false,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnCancelIcon: Icons.close,
    btnCancelColor: Colors.grey,
    btnOkIcon: icon ?? Icons.delete,
    btnOkColor: btnOkColor,
    buttonsTextStyle: TextStyle(fontSize: 17.sp),
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    // texts
    title: 'Verification'.tr,
    desc: txt ?? 'Are you sure you want to delete this image'.tr,
    btnCancelText: 'cancel'.tr,
    btnOkText: btnOkText!.tr ,

    // buttons functions
    btnOkOnPress: () {
      shouldDelete = true;
    },
    btnCancelOnPress: () {
      shouldDelete = false;
    },




  ).show();
  return shouldDelete;
}


void showGetSnackbar(String title,String desc,{Color? color}){
  Get.snackbar(

    title,
    desc,
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor:color?? Colors.redAccent.withOpacity(0.8),
    colorText: Colors.white,
  );
}





showSuccess(String sucText) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogBackgroundColor,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.leftSlide,
    dialogType: DialogType.success,
    padding: EdgeInsets.only(top: 18),
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: TextStyle(fontSize: 14),
    desc: sucText,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
      //btnOkPress!();
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}
