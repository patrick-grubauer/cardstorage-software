import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/Login/Utils/app_preference.dart';
import 'package:rfidapp/pages/account/account_page.dart';
import 'package:rfidapp/provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = AppPreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 125,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Einstellungen",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor)),
        ),
        body: Table(
          border: TableBorder.all(color: Theme.of(context).dividerColor),
          children: [
            TableRow(children: [
              buildSettingsButton("Account", Icons.person),
            ]),
            TableRow(children: [
              buildSettingsButton("Benachrichtigungen", Icons.notifications),
            ]),
            TableRow(children: [
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 8),
                color: Theme.of(context).cardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mode),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Dark-Mode',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400)),
                      ],
                    ),

                    //TODO Hardcoded

                    Align(
                        alignment: Alignment.centerRight,
                        child: buildChangeThemeMode(context)),
                  ],
                ),
              )
            ])
          ],
        ));
  }

  Widget buildSettingsButton(String text, IconData icon) {
    return ButtonTheme(
      padding: EdgeInsets.symmetric(
          vertical: 7.0, horizontal: 8.0), //adds padding inside the button
      materialTapTargetSize: MaterialTapTargetSize
          .shrinkWrap, //limits the touch area to the button area
      minWidth: double.infinity, //wraps child's width
      height: 0, //wraps child's height
      child: RaisedButton(
          color: Theme.of(context).cardColor,
          onPressed: () {},
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(icon),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
          )), //your original button
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Switch(
        activeColor: Theme.of(context).secondaryHeaderColor,
        value: isDark,
        onChanged: (value) async {
          await AppPreferences.setIsOn(value);
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          isDark = value;
          setState(() {
            provider.toggleTheme(value);
          });
        });
  }
}