import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myLightTheme.copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: myLightTheme.primaryColor,
      )),
      darkTheme: myDarkTheme.copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: myDarkTheme.primaryColor,
      )),
      home: PriceScreen(),
    );
  }
}

ThemeData myLightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.grey[800],
  primaryColor: Colors.grey[900],
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.black),
    subtitle1: TextStyle(color: Colors.black),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 5,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
  ),
);

ThemeData myDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  accentColor: Colors.grey[100],
  primaryColor: Colors.grey[200],
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.white),
    subtitle1: TextStyle(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 5,
  ),
  cardTheme: CardTheme(
    color: Colors.black,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color(0xff171717),
  )
);
