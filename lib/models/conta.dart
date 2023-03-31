import 'dart:convert';

import '../main.dart';

class Conta {
  String? name;
  String? number;


  Conta({this.name, this.number});

  Conta.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];

  }

  @override
  String toString() {
    return 'name: ${name}/ '
        'number: ${number}/ ';
  }

  static Map<String, dynamic> toJson(Conta conta) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = conta.name;
    data['number'] = conta.number;

    return data;
  }

  ///encode-decode LIST
  static String encodeList(List<Conta> contas) {
    print('## encoding contas_STRING...');

    return json.encode(
      contas.map<Map<String, dynamic>>((conta) => Conta.toJson(conta)).toList(),
    );
  }

  static List<Conta> decodeList(String contas) {
    print('## decoding contas_STRING...');
    return (json.decode(contas) as List<dynamic>).map<Conta>((conta) => Conta.fromJson(conta)).toList();
  }
}

void addContaToPrefs(Conta newConta) {
  List<Conta> contasList = [];


  /// get contas from prefs if exist
  String savedContasString = sharedPrefs!.getString('saved_contas') ?? '' ;
  print('## <${savedContasString.length}>savedContasString');
  if(savedContasString!='') contasList = Conta.decodeList(savedContasString);
  // /////

  /// add new item
  contasList.add(newConta);
  print('## conta_added: <${contasList.length}>caracter_added');
  // /////
  /// save items to prefs after change
  String encodedContasString = Conta.encodeList(contasList);
  print('## <${encodedContasString.length}>encodedContasString');
  sharedPrefs!.setString('saved_contas', encodedContasString);
  // /////
  sharedPrefs!.reload();

}

List<Conta> getContasFromPrefs() {
  String savedContasString = sharedPrefs!.getString('saved_contas') ?? '';
  print('## <${savedContasString.length}>savedContasString');
  List<Conta> contasList = [];

  if (savedContasString != '') contasList = Conta.decodeList(savedContasString);
  print('## CONTA_number: ${contasList.length}');

  return contasList;
}
