import 'dart:io';
import 'package:contacts_service/contacts_service.dart'as ctc;
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:teleffony/manager/styles.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teleffony/categDialogs/addCategView.dart';
import 'package:teleffony/categDialogs/modifyCategView.dart';
import 'package:teleffony/main.dart';
import 'package:teleffony/manager/myVoids.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:teleffony/models/categ.dart';
import 'package:teleffony/models/conta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'manager/pickImage.dart';

class HomeCtr extends GetxController {
  final SmsQuery query = SmsQuery();
  List<Categ> foundCategs = [];
  List<Categ> allCategs = [];

  List<GlobalKey<ExpansionTileCardState>> keyCap = [];
  String searchValue = '';

  GlobalKey<FormState> formkeyCateg = GlobalKey<FormState>();

  TextEditingController categNameCtr = TextEditingController(); //
  PickedFile? categImage;
  String oldCategImagePath = '';

  Categ selectedCateg = Categ();
  int selectedCategIndex = 0;

  bool firstLoading = true;
  bool oneByOne = true;
  bool switchAddCateg = false;

  @override
  void onInit() {
    super.onInit();

    getAllCategs();
  }

  // fetch all SMSs from device
  void getAllCategs({bool showSnack = false}) async {
    Future.delayed(Duration.zero, () async {
      showDialog(
          // show loading window
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Some text
                    Text('Loading...'.tr)
                  ],
                ),
              ),
            );
          });

      /// Fetch all categories ////////////////

      List<Categ> initialCategs = getCategsFromPrefs();

      /// /////////////////////////////////////:

      Navigator.of(navigatorKey.currentContext!).pop(); // hide loading window
      firstLoading = false;

      allCategs = initialCategs;
      //printAllCategs();

      foundCategs = allCategs;

      keyCap = List<GlobalKey<ExpansionTileCardState>>.generate(
          foundCategs.length+40,
              (index) => GlobalKey(debugLabel: 'key_$index'),
          growable: true); // create this to expand categs after search
      //print('## all categs number: ${allCategs.length}');
      update();

      // show snackBar
      SnackBar snackBar = SnackBar(
        content: Text(foundCategs.isNotEmpty ? '${foundCategs.length} ' + 'categories loaded successfully'.tr : 'no categories found'.tr),
      );
      if (showSnack) ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    });
  }

  void printAllCategs(){
    for (int i = 0; i < allCategs.length; i++) {
      print('## ${allCategs[i].toString()}');
      //print('## get= categ<${allCategs[i].name}>at<$i>');
    }

  }

  switchCategsBar(){
    switchAddCateg = !switchAddCateg;
    update();
  }
  // This function is called whenever the search text field changes
  void runFilter(String searchKeyword) {
    print('## running filter ...');
    List<Categ> results = [];
    if (searchKeyword.isEmpty) {
      /// all categs
      // if the search field is empty or only contains white-space, we'll display all users
      results = allCategs;
    } else {
      /// filtred categs
      results = allCategs.where((Categ categ) {
        return (
            //categ.name!.toLowerCase().contains(searchKeyword.toLowerCase()) ||
            categ.contacts.any((contact) =>
                contact.name!.toLowerCase().contains(searchKeyword.toLowerCase()) ||
                contact.number!.toLowerCase().contains(searchKeyword.toLowerCase())));
      }).toList();
    }

    foundCategs = results;

    Future.delayed(Duration(milliseconds: 80), () async {
      if (searchValue != '' && foundCategs.isNotEmpty) {
        for (GlobalKey<ExpansionTileCardState> key in keyCap) {
          key.currentState?.expand();
        }
      } else {
        for (GlobalKey<ExpansionTileCardState> key in keyCap) {
          key.currentState?.collapse();
        }
      }
    });
    update(); // Refresh the UI
  }


  bool containsCategWithName(List<Categ> categs, String name) {
    for (Categ categ in categs) {
      if (categ.name == name) {
        return true;
      }
    }
    return false;
  }
  void removeCategFromAll() {
    showNoHeader(txt:'Are you sure you want to delete this category'.tr).then((toDelete) async {
      if (toDelete) {
        if(containsCategWithName(allCategs,selectedCateg.name!)){
          allCategs.removeWhere((categ) => categ.name == selectedCateg.name!);

          refreshAllCateg(withKeys: true);
          Get.back();

          //showSuccess('category removed successfully'.tr);

          oldCategImagePath='';
          categNameCtr.clear();
          categImage = null;
          update();
        }
      }
    });

  }

  Future<void> addCategToAll() async {

    if(!containsCategWithName(allCategs,categNameCtr.text)){
      if (formkeyCateg.currentState!.validate()) {
        String savedImagePath = await saveImageToStorage(categImage);
        Categ newCateg = Categ(name: categNameCtr.text, img: savedImagePath, contacts: []);

        /// save added categ
        allCategs.add(newCateg);
        refreshAllCateg(withKeys: true);

        // //////
        Get.back();

        showSuccess('category added successfully'.tr);

        oldCategImagePath = '';
        categNameCtr.clear();
        categImage = null;
        update();
      } else {
        //showGetSnackbar('you need to fill fields'.tr);
      }

    }else{
      showGetSnackbar('you cant\'t add category'.tr,'category name already exists'.tr);

    }

  }

  Future<void> updateCategToAll() async {
    if(!containsCategWithName(allCategs,categNameCtr.text) || (categNameCtr.text==selectedCateg.name)){
      if (formkeyCateg.currentState!.validate()) {
        String savedImagePath = await saveImageToStorage(categImage);

        Categ updatedCateg = Categ(
            name: categNameCtr.text,
            img: oldCategImagePath != '' ? oldCategImagePath : savedImagePath,
            contacts: selectedCateg.contacts
        );


        /// save updated categ
        allCategs[selectedCategIndex] = updatedCateg;
        refreshAllCateg(withKeys: true);
        // //////
        Get.back();
        showSuccess('category updated successfully'.tr);

        categNameCtr.clear();
        categImage = null;
        update();
      }else {
        //showGetSnackbar('you need to fill fields'.tr);
      }
    }else{
      showGetSnackbar('you cant\'t update category'.tr,'category name already exists'.tr);

    }
  }

  refreshAllCateg({bool withKeys =false}){
    replaceCategInPrefs(allCategs);
    if(!withKeys){
      getAllCategs();


    }else{
      allCategs = getCategsFromPrefs();
      foundCategs = allCategs;
      update();
    }

  }
  void addContaToCateg(Conta conta) {

    selectedCateg.contacts.add(conta);
    print('## selectedCateg_afterADD=> $selectedCateg');
    allCategs[selectedCategIndex] = selectedCateg;
    refreshAllCateg(withKeys: true);
    //runFilter(searchValue);

    //showSuccess('contact has been added successfully'.tr);
  }
  void removeContaFromCateg(Conta conta) {

    List<Conta> _contacts = selectedCateg.contacts;//get contacts
    _contacts.removeWhere((c) => c.name == conta.name!);//delete specific contact
    selectedCateg.contacts = _contacts;//update new contact

    allCategs[selectedCategIndex] = selectedCateg;
    refreshAllCateg(withKeys: true);
    if(searchValue!='') runFilter(searchValue);

    //showSuccess('contact has been removed successfully'.tr);
  }

  void selectCateg(Categ categ) {
    selectedCateg = allCategs.firstWhere((c) => c.name == categ.name);
    selectedCategIndex = allCategs.indexWhere((c) => c.name == categ.name);

    print('## selected_categ: <$selectedCateg>at<$selectedCategIndex>');
  }

  void makeCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';

    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw '## Could not launch $telScheme';
    }
  }
  deleteImage() {
    categImage = null;
    update();
  }

  proposeDeleteImgFromDevice() {
    showNoHeader().then((toDelete) async {
      if (toDelete) {
        ///delete from internal storage
        final file = File(oldCategImagePath);
        if (await file.exists()) {
          await file.delete();
          oldCategImagePath = '';

          Categ updatedCateg =Categ(
           name: selectedCateg.name,
           img: '',
           contacts: selectedCateg.contacts
         );
          allCategs[selectedCategIndex] = updatedCateg;
          refreshAllCateg(withKeys: true);

          categImage = null;
          update();

          print('## Image deleted successfully');
        } else {
          print('## Image to delete not found');
        }
      }
    });
  }

  updateImage(PickedFile? image) {
    if (image != null) {
      categImage = image;
      update();
    }
  }

  Future<String> saveImageToStorage(PickedFile? img) async {
    String imagePath = '';
    if (img != null) {
      //save image to local storage
      final directory = await getApplicationDocumentsDirectory();
      final String duplicateFilePath = directory.path;

      //final fileName = path.basename(img!.path);
      //File imgg = File(img.path);

      final File file = File('$duplicateFilePath/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(await img.readAsBytes());

      //final File localImage = await imgg.saveTo('$duplicateFilePath/$fileName');

      imagePath = file.path;
      //sharedPrefs!.setString('${categNameCtr.text}', file.path);
    }
    print('## <image_Path>="$imagePath"');

    return imagePath;
  }

  ImageProvider retreiveImageFromStorage(String imagePrefsKey) {
    return FileImage(File(sharedPrefs!.getString(imagePrefsKey)!));
  }


  ///add contact types
  Future<void> insertConta() async {
    if (await FlutterContacts.requestPermission()) {
      ctc.Contact? newAddedContact = await ctc.ContactsService.openContactForm();
      if (newAddedContact != null) {
        Conta newAddedConta = Conta(
          name: newAddedContact.givenName ?? 'unnamed',
          number: newAddedContact.phones![0].value,
        );
        print('## newAddedConta: <$newAddedConta>');
        addContaToCateg(newAddedConta);
      } else {
        print('## Contact insertion cancelled or failed');
      }
    }
  }
  Future<void> pickConta() async {
    if (await FlutterContacts.requestPermission()) {
      final pickedContact = await FlutterContacts.openExternalPick();
      Conta newPickedConta = Conta(
        name: pickedContact!.name.first ?? 'unnamed',
        number: pickedContact.phones[0].number,
      );
      print('## newPickedConta: <$newPickedConta>');
      addContaToCateg(newPickedConta);
    }
  }
  Future<void> pickSocialMedia() async {
    showGetSnackbar(
        'This feature is not available at the moment'.tr,
    '',

      color: Colors.black38
    );
  }

// show addContact window
   addContaDialog() {
    return AlertDialog(
      title: Text('Add New Contact'.tr),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Get.back();
                  await insertConta();
                },
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text(
                  'New Contact',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  Get.back();

                  await pickConta();
                },
                icon: Icon(Icons.contacts, color: Colors.white),
                label: Text(
                  'Pick Contact',
                  style: TextStyle(color: primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  primary: secondaryColor.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  //Get.back();

                  pickSocialMedia();
                },
                icon: Icon(Icons.groups, color: Colors.white),
                label: Text(
                  'Social Media',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: accentColor.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // show addCateg window
   addCategDialog() {
   return AlertDialog(
      title: Text('Add New Category'.tr),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: AddCategView(),
    );
  }

  // show modifyCateg window
   modifyCategDialog() {
    return AlertDialog(
       title: Text('Edit Category'.tr),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(
           Radius.circular(12.0),
         ),
       ),
       content: ModifyCategView(),
     );
  }
  void showAnimDialog(child,{DialogTransitionType? animationType,int? milliseconds}){
    showAnimatedDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return child;
      },
      animationType:animationType?? DialogTransitionType.slideFromTop,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: milliseconds??500),
    );
  }

}


