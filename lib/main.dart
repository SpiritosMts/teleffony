import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleffony/homeScreen.dart';
import 'package:teleffony/homeScreen_ctr.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:teleffony/manager/test/test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:teleffony/manager/intro.dart';
import 'package:teleffony/manager/bindings.dart';
import 'package:teleffony/manager/myLocale/myLocale.dart';
import 'package:teleffony/manager/myLocale/myLocaleCtr.dart';
import 'package:telephony/telephony.dart' as tlf;


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
  //static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
              GetPage(name: '/', page: () => introTimes<444 ? OnBoardingPage():HomeScreen()),
              //GetPage(name: '/', page: () => HomeScreen()),
              //GetPage(name: '/', page: () => ScreenManager()),//in test mode

            ],
          );
        }
    );
  }
}

/// Buttons Page Route
class ScreenManager extends StatefulWidget {
  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}


class _ScreenManagerState extends State<ScreenManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[


          TextButton(
              onPressed: () {
                Get.to(() => HomeScreen());
              },
              child: Text('App')),



          TextButton(
              onPressed: () {
                Get.to(() => FlutterContactsExample());
              },
              child: Text('FlutterContactsExample')),


          TextButton(
              onPressed: () async{

              },
              child: Text('showAnimatedDialog')),
          TextButton(
              onPressed: () {
                //sharedPrefs!.remove('saved_purchases');
                sharedPrefs!.clear();
                print('##prefs_cleared');

              },
              child: Text('clear prefs')),
          TextButton(
              onPressed: () {
                Get.to(() => OnBoardingPage());
              },
              child: Text('intro')),

        ],
      ),
    );
  }
}
