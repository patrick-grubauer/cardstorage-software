import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/Widget/date_picker.dart';

TextEditingController vonTextEdidtingcontroller = TextEditingController();
TextEditingController bisTextEdidtingcontroller = TextEditingController();

Future<void> buildReservatePopUp(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: const Text('Reservierung'), actions: [
          Column(
            children: [
              buildTimeChooseField(context, "Von:", vonTextEdidtingcontroller),
              const SizedBox(height: 20),
              buildTimeChooseField(context, "Bis:", bisTextEdidtingcontroller),
              const SizedBox(height: 20),
              ElevatedButton(
                  // ignore: avoid_print
                  onPressed: () => print('tbc'),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
                    child: Text(
                      'Jetzt Reservieren',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          )
        ]);
      });
}

Widget buildTimeChooseField(BuildContext context, String text,
    TextEditingController editingController) {
  return Row(children: [
    SizedBox(
      width: 40,
      child: Text(text),
    ),
    // SizedBox(
    //   width: 15,
    // ),
    SizedBox(
      height: 40,
      width: 200,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: TextField(
              controller: editingController,
              readOnly: true,
              decoration: const InputDecoration(
                prefixText: 'prefix',
                prefixStyle: TextStyle(color: Colors.transparent),
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () {
                buildDateTimePicker(text, editingController, context);
              }),
        ],
      ),
    )
  ]);
}
