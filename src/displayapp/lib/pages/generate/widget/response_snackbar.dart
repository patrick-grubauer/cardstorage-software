import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';

class SnackbarBuilder {
  static void build(SnackbarType snackbarType, BuildContext context,
      bool successful, dynamic content) {
    late SnackBar snackBar;
    if (successful && SnackbarType.User == snackbarType) {
      snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Anmeldung erfolgreich!',
            message: '',
            contentType: ContentType.success,
          ));
    } else if (successful && SnackbarType.Karten == snackbarType) {
      if (successful && SnackbarType.User == snackbarType) {
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Karte wird heruntergelassen!',
              message: '',
              contentType: ContentType.success,
            ));
      }
    } else {
      snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Etwas ist schiefgelaufen!',
            message: content.toString(),

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}