import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkLoginStatus() {
    Future.delayed(Duration(seconds: 1, milliseconds: 500), () {

      FirebaseAuth _auth = FirebaseAuth.instance;
      User _user = _auth.currentUser;

      //print(_user.uid);
      if(_user == null) {
        Future(() {
          Navigator.pushReplacementNamed(context, '/signup');
        });
      }
      else {
        Future(() {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    });
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset('assets/images/icon.png'), //TODO: design app logo
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                        child: Text(
                          'Covid App', //TODO: think of app name
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
