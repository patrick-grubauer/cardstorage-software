import 'package:flutter/material.dart';

Expanded generateButton(BuildContext context, String buttonText,
    IconData buttonIcon, MaterialPageRoute route) {
  return Expanded(
    child: FloatingActionButton.extended(
      label: Text(buttonText),
      icon: Icon(buttonIcon),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
      onPressed: () {
        Navigator.push(context, route);
      },
    ),
  );
}
