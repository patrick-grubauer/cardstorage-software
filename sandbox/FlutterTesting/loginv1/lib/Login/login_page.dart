import 'package:flutter/material.dart';
import 'package:loginv1/Login/user_secure_storage.dart';
import 'package:loginv1/Utilities/colors.dart';
import 'package:loginv1/User/user_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberValue = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color borderColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Brightness brightness =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness;
    if (brightness == Brightness.dark) {
      borderColor = Colors.white;
    }
    init();
  }

  Future init() async {
    final rememberState = await UserSecureStorage.getRememberState() ?? '';

    if (rememberState == "true") {
      final email = await UserSecureStorage.getUsername() ?? '';
      final password = await UserSecureStorage.getPassword() ?? '';
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        if (rememberState == "true") {
          rememberValue = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildGreeting(this.context),
            buildEmail(this.context),
            const SizedBox(
              height: 9,
            ),
            buildPassword(this.context),
            buildRememberMe(this.context),
            const SizedBox(
              height: 20,
            ),
            buildSignIn(context),
            const SizedBox(
              height: 15,
            ),
            buildCreateAccount(this.context),
            const SizedBox(
              height: 15,
            ),
            buildChangePassword(context)
          ],
        ),
      ),
    );
  }

  Widget buildGreeting(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
          child: Text('Guten',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 175.0, 0.0, 0.0),
          child: Text('Tag',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(130.0, 175.0, 0.0, 0.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato",
                  color: ColorSelect.greenAccent)),
        )
      ],
    );
  }

  Widget buildEmail(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 0, right: 0),
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'E-Mail',
        ),
      ),
    );
  }

  Widget buildPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: TextFormField(
        controller: passwordController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password',
        ),
        obscureText: true,
      ),
    );
  }

  Widget buildRememberMe(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 0),
      child: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        activeColor: ColorSelect.greenAccent,
        title: const Text("Remember me"),
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

  Widget buildCreateAccount(BuildContext context) {
    return SizedBox(
        width: 500,
        height: 60,
        child: OutlinedButton.icon(
          icon: Icon(
            Icons.create,
            color: borderColor,
          ),
          label: Text(
            "Erstelle einen Account",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: borderColor),
          ),
          onPressed: () => print("it's pressed"),
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 2.5, color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ));
  }

  Widget buildSignIn(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          //check if login was succesfull (email and password are vaild)
          //TODO if not then change rememberState and rememberValue to false
          if (rememberValue) {
            UserSecureStorage.setUsername(emailController.text);
            UserSecureStorage.setPassword(passwordController.text);
          }
          UserSecureStorage.setRememberState(rememberValue.toString());
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserPage())); //open app
        },
        // style: ElevatedButton.styleFrom(
        //   padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),

        // ),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorSelect.greenAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ))),
        child: const Text(
          'SIGN IN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildChangePassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Password vergessen?',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        SizedBox(width: 5.0),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/signup');
          },
          child: Text(
            'Passwort ändern',
            style: TextStyle(
                color: ColorSelect.greenAccent,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(
                      title: 'asd',
                    )));
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}