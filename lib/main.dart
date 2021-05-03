import 'package:flutter/material.dart';
import 'package:covid_app/screens/splashScreen.dart';
import 'package:covid_app/screens/signupScreen.dart';
import 'package:covid_app/screens/loginScreen.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.2,
        overlayColor: Colors.black,
        overlayWidget: Center(
          child: SpinKitRing(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: MaterialApp(
          routes: {
            '/': (context) => SplashScreen(),
            '/signup': (context) => DoubleBack(message: 'Press back again to close', child: SignupScreen()),
            '/login': (context) => DoubleBack(message: 'Press back again to close', child: LoginScreen()),
          },
          theme: ThemeData(
            primaryColor: Colors.blueAccent, //TODO: Decide theme colors
            //To use hex => Color(0xff_HEX_)
            //define default font family here,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

