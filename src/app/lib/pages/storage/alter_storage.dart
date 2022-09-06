import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/config/values/tab2_text_values.dart';
import 'package:app/domain/values/tab2_storage_values.dart';

// ToDo: The Api needs to be changed in the future

Tab2StorageValuesProvider tab2SSVP = new Tab2StorageValuesProvider();
Tab2AlterStorageDescriptionProvider tab2ASDP =
    new Tab2AlterStorageDescriptionProvider();

class StorageSettings extends StatefulWidget {
  StorageSettings(int id, {Key? key}) : super(key: key) {
    tab2SSVP.setID(id);
  }

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              tab2ASDP.getAppBarTitle(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [InputFields()],
              )),
        ));
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return createStorage(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        )));
      },
    );
  }

  Widget createStorage(BuildContext context, List<Data>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        ListTile(
          leading: Icon(
            Icons.description,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getNameFieldName(),
                hintText: data![tab2SSVP.getId()].title,
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            onChanged: (value) => tab2SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.network_wifi,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\.])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getIpAdressFieldName(),
                hintText: data[tab2SSVP.getId()].id.toString(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setIpAdress(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.format_list_numbered,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getNumberOfCardsFieldName(),
                hintText: data[tab2SSVP.getId()].id.toString(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setNumberOfCards(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_pin,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getLocationFieldName(),
                hintText: data[tab2SSVP.getId()].title.toString(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            onChanged: (value) => tab2SSVP.setLocation(value),
          ),
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Column(children: [
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        tab2ASDP.getButtonName(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).secondaryHeaderColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
      ]),
    ));
  }
}

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}