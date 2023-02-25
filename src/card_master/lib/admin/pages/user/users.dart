import 'dart:convert';

import 'package:card_master/admin/pages/card/search.dart';
import 'package:card_master/admin/pages/user/user_builder.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/createUser.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';

class UsersSettings extends StatefulWidget {
  const UsersSettings({Key? key}) : super(key: key);

  @override
  State<UsersSettings> createState() => _StorageViewState();
}

class _StorageViewState extends State<UsersSettings> {
  List<Users> listOfUsers = [];
  List<Users> listOfFilteredUsers = [];
  TextEditingController txtQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await Data.checkAuthorization(
      context: context,
      function: fetchUsers,
    );
    List jsonResponse = json.decode(response!.body);
    listOfUsers = jsonResponse.map((data) => Users.fromJson(data)).toList();

    listOfFilteredUsers = listOfUsers;

    setState(() {});
  }

  void search(String query) async {
    if (query.isEmpty) {
      fetchData();
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    List<Users> tmp = [];

    for (int i = 0; i < listOfUsers.length; i++) {
      var name = listOfUsers[i].email.toString().toLowerCase();
      if (name.contains(query)) {
        tmp.add(listOfUsers[i]);
      }
    }

    listOfFilteredUsers = tmp;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GenerateReloadButton(fetchData),
        appBar: AppBar(
          title: Text(
            "Benutzer",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildSeacrh(context, txtQuery, search),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(children: [
                ListUsers(
                  listOfUsers: listOfFilteredUsers,
                )
              ]),
            ),
          ]),
        ));
  }
}
