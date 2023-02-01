// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/authentication/authentication.dart';
import 'package:rfidapp/domain/authentication/login.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/login_status_type.dart';
import 'package:rfidapp/domain/enums/timer_actions_type.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';
import 'package:rfidapp/pages/generate/widget/default_custom_button.dart';
import 'package:rfidapp/pages/generate/pop_up/request_timer.dart';
import 'package:rfidapp/pages/generate/widget/response_snackbar.dart';
import 'package:rfidapp/pages/login/storage_select.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/microsoft_user.dart';
import 'package:rfidapp/domain/enums/snackbar_type.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({Key? key}) : super(key: key);
  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  bool rememberValue = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildGreeting(this.context),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: DefaultCustomButton(
                    bgColor: ColorSelect.blueAccent,
                    borderColor: ColorSelect.blueAccent,
                    text: 'SIGN IN via Microsoft',
                    textColor: Colors.white,
                    onPress: () {
                      sigIn();
                    },
                  )),
              buildRememberMe(this.context),
              const SizedBox(
                height: 50,
              ),
              buildProblemsText(context),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGreeting(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
          child: const Text('Guten',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
          child: const Text('Tag',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(160.0, 200.0, 0.0, 0.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato",
                  color: Theme.of(context).secondaryHeaderColor)),
        )
      ],
    );
  }

  Widget buildRememberMe(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 0),
      child: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        activeColor: Theme.of(context).secondaryHeaderColor,
        title: const Text("Login speichern"),
        //contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        value: rememberValue,

        onChanged: (newValue) {
          setState(() {
            rememberValue = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget buildProblemsText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Probleme?',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () async {
            EmailPopUp(
                    context: context,
                    to: "admin@gmail.com",
                    subject: "Frage bei Rfid CardManagement App",
                    body: " Guten Tag Admin,")
                .show(
                    //send to mail
                    );
          },
          child: Text(
            'Stelle Sie eine Frage.',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  void sigIn() async {
    var loginStatus = await Login.start(rememberValue);
    if (loginStatus != null) {
      switch (loginStatus.item1) {
        case LoginStatusType.ALREADYLOGGEDIN:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomNavigation()),
              (Route<dynamic> route) => false);
          break;

        case LoginStatusType.NEWLOGIN:
          await StorageSelectPopUp.build(context);
          if (StorageSelectPopUp.getSuccessful()) {
            var reqTimer = RequestTimer(
                context: context,
                action: TimerAction.SIGNUP,
                email: jsonDecode(loginStatus.item2!)["mail"],
                storagename: StorageSelectPopUp.getSelectedStorage());
            await reqTimer.startTimer();
            if (reqTimer.getSuccessful()) {
              MicrosoftUser.setUserValues(jsonDecode(loginStatus.item2!));
              UserSecureStorage.setRememberState(rememberValue.toString());
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const BottomNavigation()),
                  (Route<dynamic> route) => false);
            }
          } else {
            SnackbarBuilder.build(SnackbarType.USER, context, false, null);
          }
          break;
        case LoginStatusType.ERROR:
          break;
      }
    }
  }
}

//try {
    //   UserSecureStorage.setRememberState(rememberValue.toString());
    //   await AadAuthentication.getEnv();
    //   await AadAuthentication.oauth!.logout();
    //   await AadAuthentication.oauth!.login();
    //   String? accessToken = await AadAuthentication.oauth!.getAccessToken();
    //   if (accessToken!.isNotEmpty) {
    //     var userResponse = await Data.getUserData(accessToken);
    //     var email = jsonDecode(userResponse!.body)["mail"];
    //     bool registered = await Data.checkUserRegistered(email);
    //     if (registered) //api get// see if user is registered
    //     {
    //       MicrosoftUser.setUserValues(jsonDecode(userResponse.body));
    //       UserSecureStorage.setRememberState(rememberValue.toString());

    //       Navigator.of(context).pushAndRemoveUntil(
    //           MaterialPageRoute(builder: (context) => const BottomNavigation()),
    //           (Route<dynamic> route) => false);
    //     } else {
    //       await StorageSelectPopUp.build(context);
    //       if (StorageSelectPopUp.getSuccessful()) {
    //         var reqTimer = RequestTimer(
    //             context: context,
    //             action: TimerAction.SIGNUP,
    //             email: email,
    //             storagename: StorageSelectPopUp.getSelectedStorage());
    //         await reqTimer.startTimer();

    //         if (reqTimer.getSuccessful()) {
    //           MicrosoftUser.setUserValues(jsonDecode(userResponse.body));
    //           UserSecureStorage.setRememberState(rememberValue.toString());
    //           Navigator.of(context).pushAndRemoveUntil(
    //               MaterialPageRoute(
    //                   builder: (context) => const BottomNavigation()),
    //               (Route<dynamic> route) => false);
    //         }
    //       } else {
    //         SnackbarBuilder.build(SnackbarType.User, context, false, null);
    //       }
    //       //removed here
    //     }
    //   } else {
    //     UserSecureStorage.setRememberState("false");
    //     setState(() {
    //       rememberValue = false;
    //     });
    //   }
    // } catch (e) {}
