import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teleffony/homeScreen_ctr.dart';
import 'package:teleffony/manager/pickImage.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:ionicons/ionicons.dart';

class AddCategView extends StatelessWidget {
  HomeCtr gc = Get.find<HomeCtr>();





  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeCtr>(
        initState: (_) {
          gc.categNameCtr.clear();
        },
        dispose: (_) {
        },
        builder: (ctr) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: gc.formkeyCateg,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    /// components
                    // categ_name
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.categNameCtr,
                        onEditingComplete: () {
                          //fieldUnfocusAll();
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(30),
                        ],
                        onTap: () {},
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(bottom: 5.0),
                          hintStyle: const TextStyle(fontSize: 13),
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'category name'.tr,
                          //hintText: 'enter new category'.tr,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "category can\'t be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    /// image
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0, top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //add image
                          ButtonTheme(
                            //minWidth: 100.w / 9,
                            child: ElevatedButton(
                              onPressed: () async {
                                PickedFile img = await showImageChoiceDialog();
                                gc.updateImage(img);
                                },
                              child: Text('Add Image'.tr),
                            ),
                          ),

                          //image_display
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: SizedBox(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        //size: Size.fromRadius(30),
                                        child: gc.categImage != null
                                            ? Image.file(
                                                File(gc.categImage!.path),
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

                                  ///delete
                                  if (gc.categImage != null)
                                    Positioned(
                                      top: -11,
                                      right: -11,
                                      child: Stack(
                                        children: [
                                          IconButton(
                                              icon: const Icon(Ionicons.ellipse), color: Colors.black, splashRadius: 1, onPressed: () {}),
                                          IconButton(
                                            icon: const Icon(Ionicons.close_circle_sharp),
                                            color: Colors.grey,
                                            splashRadius: 1,
                                            onPressed: () {
                                              gc.deleteImage();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// buttons
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //cancel
                          TextButton(
                            style: borderStyle(),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel".tr,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          //add
                          TextButton(
                            style: filledStyle(),
                            onPressed: () async {
                               gc.addCategToAll();
                            },
                            child: Text(
                              "Add".tr,
                              style: TextStyle(color: Theme.of(context).backgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
