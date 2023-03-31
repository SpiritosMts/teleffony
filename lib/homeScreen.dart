import 'dart:io';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:math';
//import 'package:sms/sms.dart';
//import 'package:flutter_sms/flutter_purchases.dart';
import 'package:teleffony/homeScreen_ctr.dart';
import 'package:teleffony/manager/myLocale/myLocaleCtr.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:get/get.dart';

//import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:ui' as ui;

import 'package:substring_highlight/substring_highlight.dart';
import 'package:teleffony/manager/tutoCtr.dart';
import 'package:teleffony/models/categ.dart';
import 'package:teleffony/models/conta.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeCtr c = Get.put(HomeCtr());
  final TutoController ttr = Get.find<TutoController>();


  Widget verticalCategCard(Categ categ, index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        child: Column(
          children: [
            ExpansionTileCard(
              animateTrailing: true,
              key: c.keyCap[index],
              title: Padding(
                padding:  EdgeInsets.only(top: 10.0,bottom: 0.0,left: currLang! =='en'?30:0,right: currLang! =='ar'?30:0),
                child: Container(
                  child:(c.oneByOne && index % 2 == 0)?
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        decoration: categ.img! ==''?  BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                        ):null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              //size: Size.fromRadius(30),
                              child: categ.img != ''
                                  ? Image.file(
                                File(categ.img!),
                                fit: BoxFit.cover,
                              )
                                  : Transform.scale(
                                scale: 0.7, // adjust the scale factor as needed
                                child: Image.asset(
                                  'assets/images/group.png',
                                  fit: BoxFit.cover,
                                  color: primaryColor.withOpacity(0.5),
                                ),
                              )
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.black38,
                        child: SizedBox(
                          width: 130,
                          child: Text(
                            categ.name!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.kalam(
                              height: 1.3,
                              textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ):
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        //color: Colors.black38,
                        child: SizedBox(
                          width: 130,
                          child: Text(
                            categ.name!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.kalam(
                              height: 1.3,
                              textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: categ.img! ==''?  BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                        ):null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              //size: Size.fromRadius(30),
                              child: categ.img != ''
                                  ? Image.file(
                                File(categ.img!),
                                fit: BoxFit.cover,
                              )
                                  : Transform.scale(
                                scale: 0.7, // adjust the scale factor as needed
                                child: Image.asset(
                                  'assets/images/group.png',
                                  fit: BoxFit.cover,
                                  color: primaryColor.withOpacity(0.5),
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              //subtitle: Text('AED'),
              subtitle:Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: SizedBox(
                  width: 15,
                  //height: 15,
                  child: Row(
                    children: [
                      Text(categ.contacts.length.toString(),
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 13
                      ),
                      ),
                      Icon(Icons.person,
                        color: Colors.black38,
                      size: 17,)
                    ],
                  ),
                ),
              ) ,
              trailing:Icon(Icons.expand_more,color: Colors.white,) ,
              children: <Widget>[

                Divider(
                  color: Colors.grey,
                  endIndent: 15,
                  indent: 15,

                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        //"add new contact" text
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: GestureDetector(
                            onTap: ()  {
                              c.selectCateg(categ);
                              c.showAnimDialog(
                                  c.addContaDialog(),
                                  animationType:DialogTransitionType.slideFromLeft
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,color: primaryColor,size: 14,),
                                SizedBox(width: 2.0),
                                Text("Add new contact".tr, style: TextStyle(color: primaryColor, fontSize: 14.0)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Column(
                            children: categ.contacts.map((conta) {
                              int idx = categ.contacts.indexOf(conta);
                              return  Padding(
                                padding: const EdgeInsets.only(left: 10.0,right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Ionicons.remove_circle),
                                          color: Colors.redAccent.withOpacity(0.8),

                                          //splashRadius: 1,
                                          onPressed: () {
                                            c.selectCateg(categ);
                                            c.removeContaFromCateg(conta);
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SubstringHighlight(
                                              maxLines: 1,
                                                text: conta.name!,
                                                term: c.searchValue,
                                                textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400
                                                ),
                                                textStyleHighlight: highlightStyle
                                            ),
                                            SizedBox(height: 2,),
                                            SubstringHighlight(
                                                text: conta.number! ,
                                                term: c.searchValue,
                                                textStyle: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.black38,
                                                ),
                                                textStyleHighlight: highlightStyle
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [

                                        SizedBox(width: 10),
                                        IconButton(
                                          icon: const Icon(Icons.call),
                                          color: Colors.greenAccent,
                                          //splashRadius: 1,
                                          onPressed: () {
                                            c.makeCall(conta.number!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black26,
              endIndent: 25,
              indent: 25,
            ),
          ],
        ),
      ),
    );
  }
  Widget createCategBtn() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: (){
          c.showAnimDialog(c.addCategDialog());

        },
        child: Container(
            // decoration:  BoxDecoration(
            //   //shape: BoxShape.circle,
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     stops: [0.0, 0.5, 1.0],
            //     colors: [primaryColor.withOpacity(0.8), secondaryColor.withOpacity(0.8), accentColor.withOpacity(0.8)],
            //   ),
            //    borderRadius: BorderRadius.circular(50),
            //   // border: Border.all(
            //   //   color: primaryColor,
            //   //   width: 0,
            //   // ),
            // ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 80,
                child: Image.asset(
                  'assets/images/add.png',
                  fit: BoxFit.cover,
                  //color: primaryColor.withOpacity(0.5),
                ),
              ),
            )),
      ),
    );
  }
  Widget horizontalCategCard(Categ categ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector  (
        onTap: (){
          c.selectCateg(categ);//update categ
          c.showAnimDialog(
              c.modifyCategDialog(),
              animationType:DialogTransitionType.fadeScale,
              milliseconds:800,
          );

        },
        child: Container(
            decoration: categ.img! ==''?  BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: primaryColor,
                width: 2,
              ),
            ):null,
            child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: SizedBox(
            width: 80,
            child: categ.img != ''
                ? Container(

                    child: Stack(
                      children: [
                        Image.file(
                          File(categ.img!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Center(
                            child: Container(
                          color: Colors.black.withOpacity(0.2),
                        )),
                        Center(
                          child: Text(
                            categ.name!.length > 7 ? '${categ.name!.substring(0, 7)}...' : categ.name!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
              child: Stack(
                children: [

                  Center(
                      child: Container(
                        color: Colors.transparent,
                      )),
                  Center(
                    child: Text(
                      categ.name!.length > 7 ? '${categ.name!.substring(0, 7)}...' : categ.name!,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        )),
      ),
    );
  }



  /// ###################################################################################
  /// ###################################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        searchBackIconTheme: IconThemeData(),
        actions: [
          IconButton(
            //key: ttr.filterKey,
            padding: EdgeInsets.only(left: 0.0),
            icon: const Icon(Icons.control_point_duplicate_outlined,
            color: Colors.black54,
            ),
            onPressed: () {
              //c.printAllCategs();
              c.switchCategsBar();


            },
          )
        ],
        searchHintText: 'search...'.tr,
        title: Row(
          children: [

            SizedBox(width: 10),
            Container(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Teleffony'.tr)),
          ],
        ),
        onSearch: (value) {
          setState(() {
            c.searchValue = value;
            c.runFilter(c.searchValue);
          });
        },
      ),
      body: GetBuilder<HomeCtr>(
        initState: (_) {

          // Future.delayed(const Duration(seconds: 1), () {
          //   ttr.showHomeTuto(context);
          // });
        },
        dispose: (_){

        },
        builder: (ctr) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: c.switchAddCateg
                      ? Container(
                          key: UniqueKey(),
                          width: 100.w,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0, top: 13.0),
                          child: SizedBox(
                            key: UniqueKey(),
                            height: 88,
                            width: 100.w,
                            child:  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: c.allCategs.length+1,
                                    itemBuilder: (context, index) {
                                      return index < c.allCategs.length ?
                                      horizontalCategCard(c.allCategs[index]):
                                      createCategBtn();
                                    })

                          ),
                        ),
                ),


                Divider(
                  color: primaryColor,
                  endIndent: 25,
                  indent: 25,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, top: 10.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: c.foundCategs.isNotEmpty
                          ? Column(
                              children: c.foundCategs.map((categ) {
                              int idx = c.foundCategs.indexOf(categ);
                              return verticalCategCard(categ, idx);
                            }).toList())
                          : c.searchValue == ''
                              ? c.firstLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'no categories found'.tr,
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 22,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  c.showAnimDialog(c.addCategDialog());

                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add,color: primaryColor,size: 17,),
                                                    SizedBox(width: 2.0),
                                                    Text("Add first category", style: TextStyle(color: primaryColor, fontSize: 17.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(
                                      'no contacts or numbers found containing'.tr + '"${c.searchValue}"',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
// ElevatedButton(
// onPressed: () {
// setState(() {
// switchAddCateg = !switchAddCateg;
// });
// },
// child: Text('Click'),
// ),