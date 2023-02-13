import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/size/size_manager.dart';
import 'package:rfidapp/provider/theme/app_themes.dart';
import 'package:rfidapp/provider/theme/theme_provider.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'domain/storage_properties.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  await StorageProperties.loadEnv();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String title = 'Light & Dark Theme';
  // ignore: prefer_typing_uninitialized_variables
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            themeMode: themeProvider.getThemeMode(),
            theme: DisplayAppThemes.lightTheme,
            darkTheme: DisplayAppThemes.darkTheme,
            home: const BottomNavigation(),
            navigatorKey: navigatorKey,
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
