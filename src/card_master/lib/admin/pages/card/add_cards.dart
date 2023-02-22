import 'package:card_master/admin/pages/card/add_card_form.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Cards> listOfCards = [];
  List<FocusS> listUnfocusedStorages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await Data.checkAuthorization(
        context: context, function: fetchStorages);
    var temp = jsonDecode(response!.body) as List;
    listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();

    if (context.mounted) {
      var resp = await Data.checkAuthorization(
          context: context, function: getAllUnfocusedStorages);

      List jsonResponse = json.decode(resp!.body);
      listUnfocusedStorages =
          jsonResponse.map((data) => FocusS.fromJson(data)).toList();
    }

    listOfStorageNames.add("-");
    for (int i = 0; i < listOfStorages.length; i++) {
      listOfStorageNames.add(listOfStorages[i].name);
    }

    for (int i = 0; i < listOfStorageNames.length; i++) {
      for (int j = 0; j < listUnfocusedStorages.length; j++) {
        if (listOfStorageNames[i] == listUnfocusedStorages[j].name) {
          listOfStorageNames.removeAt(i);
          setState(() {});
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Karte hinzufügen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              BuildCard(
                listOfCards: listOfCards,
                listOfStorageNames: listOfStorageNames,
                listOfStorages: listOfStorages,
              )
            ],
          ),
        ));
  }
}

class BuildCard extends StatefulWidget {
  final List<String> listOfStorageNames;
  final List<Storages> listOfStorages;
  final List<Cards> listOfCards;

  const BuildCard({
    Key? key,
    required this.listOfStorageNames,
    required this.listOfCards,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<BuildCard> createState() => _BuildCardState();
}

class _BuildCardState extends State<BuildCard> {
  String selectedStorage = "-";
  Cards card = Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    super.initState();
  }

  void setCardName(String value) {
    card.name = value;
  }

  void setSelectedStorage(String value) {
    setState(() {
      selectedStorage = value;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: card.name);
    final formKey = GlobalKey<FormState>();

    return Expanded(
        child: Column(
      children: [
        BuildAddCardForm(
            listOfStorageNames: widget.listOfStorageNames,
            listOfCards: widget.listOfCards,
            context: context,
            formKey: formKey,
            nameController: nameController,
            setCardName: setCardName,
            selectedStorage: selectedStorage,
            setSelectedStorage: setSelectedStorage,
            card: card)
      ],
    ));
  }
}