import 'package:flutter/material.dart';
import 'package:covid_app/screens/splashScreen.dart';
import 'package:covid_app/screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.blueAccent, //TODO: Decide theme colors
          //To use hex => Color(0xff_HEX_)
          accentColor: Colors.white,
          //define default font family here,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}

