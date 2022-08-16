import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:rfidapp/service/password/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formRepeatKey = GlobalKey<FormState>();
  double passwordStrength = 0;
  bool disableRepeatPassword = true;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(children: <Widget>[
          buildRegisterText(this.context),
          buildFirstName(this.context),
          buildLastName(this.context),
          buildEmail(this.context),
          buildPassword(this.context),
          buildRepeatPassword(this.context),
          const SizedBox(
            height: 9,
          ),
          buildProgressbar(this.context)
        ]),
      ),
    );
  }

  buildFirstName(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),

      // ignore: prefer_const_constructors
      child: TextField(
        controller: firstnameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Vorname',
        ),
      ),
    );
  }

  buildLastName(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      // ignore: prefer_const_constructors
      child: TextField(
        controller: lastNameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Nachname',
        ),
      ),
    );
  }

  buildRegisterText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 0, right: 0),
      // ignore: prefer_const_constructors
      child: const Text('Registrierung',
          style: TextStyle(
              fontSize: 53.0, fontWeight: FontWeight.w900, fontFamily: "Lato")),
    );
  }

  buildEmail(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      // ignore: prefer_const_constructors
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Email',
        ),
      ),
    );
  }

  buildPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Password',
              ),
              onChanged: (value) {
                _formKey.currentState!.validate();
                setState(() {
                  passwordStrength = Validator().validatePassword(value);
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                } else {
                  //call function to check password

                  if (passwordStrength == 1) {
                    setState(() {
                      disableRepeatPassword = false;
                    });
                    return null;
                  } else {
                    setState(() {
                      disableRepeatPassword = true;
                    });
                    repeatPasswordController.text = '';
                    return " Password should contain Capital, small letter & Number & Special";
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  buildRepeatPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: Form(
        key: _formRepeatKey,
        child: Column(
          children: [
            TextFormField(
              controller: repeatPasswordController,
              readOnly: disableRepeatPassword,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Passwort wiederholen',
              ),
              onChanged: (value) {
                _formRepeatKey.currentState!.validate();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                } else {
                  if (passwordController.text !=
                      repeatPasswordController.text) {
                    return "Die Passwoerte sind nicht ident";
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
    //        readOnly: true,
  }

  buildProgressbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 0, right: 0),
      child: LinearProgressIndicator(
        value: passwordStrength,
        backgroundColor: Colors.grey[300],
        minHeight: 5,
        color: passwordStrength <= 1 / 4
            ? Colors.red
            : passwordStrength == 2 / 4
                ? Colors.yellow
                : passwordStrength == 3 / 4
                    ? Colors.blue
                    : Colors.green,
      ),
    );
  }
}
