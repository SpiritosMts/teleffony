import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleffony/homeScreen.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:teleffony/manager/intro.dart';
import 'package:teleffony/manager/bindings.dart';
import 'package:teleffony/manager/myLocale/myLocale.dart';
import 'package:teleffony/manager/myLocale/myLocaleCtr.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? sharedPrefs;


int introTimes = 0;


void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  introTimes = sharedPrefs!.getInt('intro')??0 ;

  runApp( MyApp());

}




class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyLocaleCtr langCtr =   Get.put(MyLocaleCtr());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,

            title: 'Teleffony',
            theme: myTheme,

            initialBinding: GetxBinding(),

            locale: langCtr.initlang,
            translations: MyLocale(),

            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => introTimes<3 ? OnBoardingPage():HomeScreen()),
              //GetPage(name: '/', page: () => ScreenManager()),//in test mode

            ],
          );
        }
    );
  }
}
