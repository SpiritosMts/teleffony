import 'dart:convert';


import 'package:teleffony/models/conta.dart';

import '../main.dart';

class Categ {
  String? name;
  String? img;
  List<Conta> contacts = const[];


  Categ({this.name, this.img, this.contacts = const [],});

  Categ.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    if (json['contacts'] != null) {
      contacts = List<Conta>.from(json['contacts'].map((c) => Conta.fromJson(c)));
    } else {
      contacts = [];
    }
  }

  @override
  String toString() {
    return 'name: ${name}/ '
        'img: ${img}/ '
        'contacts: ${contacts}/ ';
  }

  static Map<String, dynamic> toJson(Categ categ) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = categ.name;
    data['img'] = categ.img;
    data['contacts'] = categ.contacts.map((c) => Conta.toJson(c)).toList();
    return data;
  }

  ///encode-decode LIST
  static String encodeList(List<Categ> categs) {
    print('## encoding categs_STRING...');

    return json.encode(
      categs.map<Map<String, dynamic>>((categ) => Categ.toJson(categ)).toList(),
    );
  }

  static List<Categ> decodeList(String categs) {
    print('## decoding categs_STRING...');
    return (json.decode(categs) as List<dynamic>).map<Categ>((categ) => Categ.fromJson(categ)).toList();
  }
}

void addCategToPrefs(Categ newCateg) {
  List<Categ> categsList = [];


  /// get categs from prefs if exist
  String savedCategsString = sharedPrefs!.getString('saved_categs') ?? '' ;
  print('## <${savedCategsString.length}>savedCategsString');
  if(savedCategsString!='') categsList = Categ.decodeList(savedCategsString);
  // /////

  /// add new item
  categsList.add(newCateg);
  print('## categ_added: <<$newCateg>>');
  print('## total_categs_number <${categsList.length}>');
  // /////
  /// save items to prefs after change
  String encodedCategsString = Categ.encodeList(categsList);
  print('## <${encodedCategsString.length}>encodedCategsString');
  sharedPrefs!.setString('saved_categs', encodedCategsString);
  // /////
  sharedPrefs!.reload();

}
void replaceCategInPrefs(List<Categ> newCategs) {
  sharedPrefs!.reload();

  /// save items to prefs after change
  String encodedCategsString = Categ.encodeList(newCategs);
  print('## <${encodedCategsString.length}>encoded_new_Categs_String');
  sharedPrefs!.setString('saved_categs', encodedCategsString);
  // /////
  sharedPrefs!.reload();

}

List<Categ> getCategsFromPrefs() {
  sharedPrefs!.reload();

  String savedCategsString = sharedPrefs!.getString('saved_categs') ?? '';
  print('## <${savedCategsString.length}>savedCategsString');
  List<Categ> categsList = [];

  if (savedCategsString != '') categsList = Categ.decodeList(savedCategsString);
  print('## CATEG_number: ${categsList.length}');

  return categsList;
}
