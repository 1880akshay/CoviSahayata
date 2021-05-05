import 'package:flutter/material.dart';
import 'package:covid_app/screens/splashScreen.dart';
import 'package:covid_app/screens/signupScreen.dart';
import 'package:covid_app/screens/loginScreen.dart';
import 'package:covid_app/screens/home.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    precacheImage(AssetImage('assets/images/bg2.jpg'), context);
    precacheImage(AssetImage('assets/images/icon.png'), context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 1,
        overlayColor: Color(0x55000000),
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
            '/home': (context) => DoubleBack(message: 'Press back again to close', child: Home()),
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

