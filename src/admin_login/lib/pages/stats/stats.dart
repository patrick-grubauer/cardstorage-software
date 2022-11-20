import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/Widget/appbar.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: Changed the API Calls to the actual API

class StatsView extends StatefulWidget {
  StatsView({Key? key}) : super(key: key);

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  String selectedStorage = "-";
  List<dynamic> dropDownValues = ["-", "78", "79"];

  @override
  void initState() {
    super.initState();
  }

  callBack(String storage) {
    setState(() {
      selectedStorage = storage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Builder(
                builder: (context) {
                  return Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      child: Text('Filter'),
                      onPressed: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 300,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Column(children: [
                                const Text(
                                  'Filter',
                                  style: TextStyle(fontSize: 30),
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                      'Storage',
                                      style: TextStyle(fontSize: 17),
                                    )),
                                    DropdownButton(
                                      value: selectedStorage,
                                      items: dropDownValues.map((valueItem) {
                                        return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem.toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue != '') {
                                            selectedStorage =
                                                newValue as String;
                                          } else {
                                            selectedStorage =
                                                newValue as dynamic;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ]),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              ListCards(cardStorage: selectedStorage)
            ],
          )),
    );
  }
}

class ListCards extends StatefulWidget {
  final String cardStorage;
  const ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _MyAppState();
}

class _MyAppState extends State<ListCards> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.cardStorage == data![index].userId.toString()) {
                  return GenerateCardWithInkWell.withoutArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/stats",
                    view: 1,
                  );
                } else if (widget.cardStorage == "-") {
                  return GenerateCardWithInkWell.withoutArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/stats",
                    view: 1,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [generateProgressIndicator(context)],
        )));
      },
    ));
  }
}
