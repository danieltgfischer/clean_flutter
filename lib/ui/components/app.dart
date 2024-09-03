import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
    const textTheme = TextTheme(
        displayLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark));

    const inputDecorationTheme = InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      floatingLabelStyle: TextStyle(color: primaryColor),
      alignLabelWithHint: true,
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: WidgetStateProperty.all(primaryColor),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
    final TextButtonThemeData textButtonTheme = TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(primaryColor),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      home: LoginPage(null),
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 171, 92, 134),
          primaryColorDark: primaryColorDark,
          primaryColorLight: primaryColorLight,
          textTheme: textTheme,
          inputDecorationTheme: inputDecorationTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          textButtonTheme: textButtonTheme),
    );
  }
}
