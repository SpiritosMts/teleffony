import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:teleffony/manager/styles.dart';
import 'package:teleffony/models/conta.dart';
import 'package:contacts_service/contacts_service.dart'as ctc;

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }


  Future<void> insertConta() async {
    if (await FlutterContacts.requestPermission()) {
      Contact? newAddedContact = await FlutterContacts.openExternalInsert();
      if (newAddedContact != null) {
        Conta newAddedConta = Conta(
          name: newAddedContact.name.first ?? 'unnamed',
          number: newAddedContact.phones[0].number,
        );
        print('## newAddedConta: <$newAddedConta>');
      } else {
        print('## Contact insertion cancelled or failed');
      }
    }
  }
  Future<void> insertConta2() async {
    if (await FlutterContacts.requestPermission()) {
      ctc.Contact? newAddedContact = await ctc.ContactsService.openContactForm();
      if (newAddedContact != null) {
        Conta newAddedConta = Conta(
          name: newAddedContact.givenName ?? 'unnamed',
          number: newAddedContact.phones![0].value,
        );
        print('## newAddedConta: <$newAddedConta>');
      } else {
        print('## Contact insertion cancelled or failed');
      }
    }
  }


  Future<void> pickConta() async {
    if (await FlutterContacts.requestPermission()) {
      Contact? pickedContact = await FlutterContacts.openExternalPick();
      // Conta newPickedConta = Conta(
      //   name: pickedContact!.name.first ?? 'unnamed',
      //   number: pickedContact.phones[0].number,
      // );
      //print('## newPickedConta: <$newPickedConta>');
      print('## newPickedConta: <$pickedContact>');
    }
  }

  Future<void> getConta() async {
    // Request contact permission
    if (await FlutterContacts.requestPermission()) {
      /// Get all contacts (lightly fetched)
      List<Contact> contacts = await FlutterContacts.getContacts();

      /// Get all contacts (fully fetched)
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);

      /// Get contact with specific ID (fully fetched)
      //Contact? contact = await FlutterContacts.getContact(contacts.first.id);

      /// Insert new contact

      // final newContact = Contact(
      //   displayName: 'AAAohn Smith',
      //   name: Name(first: 'AAAohn Smith'),
      //   phones: [Phone('0005454567')],//if first name not defined it took the number as first name
      // );
      // await newContact.insert().then((value) => print('## added contact')).catchError((error) => print("Failed to add contact: $error"));

      /// Update contact
      // contact!.name.first = 'Bob';
      // await contact.update();

      /// Delete contact
      //await contact.delete();

      /// Open external contact app to view/edit/pick/insert contacts.
      //await FlutterContacts.openExternalView(contact.id);
      //await FlutterContacts.openExternalEdit(contact!.id);


      //await insertConta();




      /// Listen to contact database changes
      //FlutterContacts.addListener(() => print('## Contact DB changed'));

      /// Create a new group (iOS) / label (Android).
      //await FlutterContacts.insertGroup(Group('', 'Coworkers'));

      /// Export contact to vCard
      //String vCard = contact.toVCard();

      /// Import contact from vCard
      // contact = Contact.fromVCard('BEGIN:VCARD\n'
      // 'VERSION:3.0\n'
      // 'N:;Joe;;;\n'
      // 'TEL;TYPE=HOME:123456\n'
      // 'END:VCARD');
    }
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      setState(() => _contacts = contacts);
      print('## contacts_number <${_contacts!.length}>');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text('flutter_contacts_example'),
        actions: [
          IconButton(
            padding: EdgeInsets.only(left: 0.0),
            icon: const Icon(Icons.get_app),
            onPressed: ()async {
             await insertConta2();
            },
          )
        ]),

        body: _body()
    );
  }


  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) =>
            ListTile(
                leading: _contacts![i].photo != null
                    ? CircleAvatar(
                  backgroundImage: MemoryImage(
                    _contacts![i].photo!,
                  ),
                  radius: 20,
                )
                    : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [getRandomColor1(), getRandomColor1()],
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    // backgroundColor: Colors.white,
                    // foregroundColor: Colors.black,
                    child: Text(
                      _contacts![i].displayName[0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                title: Text(_contacts![i].displayName),
                onTap: () async {
                  final fullContact = await FlutterContacts.getContact(_contacts![i].id);
                  Conta newConta = Conta(
                    name: fullContact!.displayName,
                    number: fullContact.phones[0].number,
                  );
                  Get.back();
                }));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;

  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(title: Text(contact.displayName)),
          body: Column(children: [
            Text('First name: ${contact.displayName}'),
            contact.photo != null
                ? Image.memory(
              contact.photo!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
                : CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/group.png',
              ),
              radius: 50,
            ),
            Text('Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
            Text('Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
          ]));
}
