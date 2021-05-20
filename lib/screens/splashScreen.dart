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
    Future.delayed(Duration(seconds: 1), () {

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
                  flex: 5,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 19,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 16,
                        child: Image.asset('assets/images/icon.png'), //TODO: design app logo
                      ),
                      Expanded(
                        flex: 19,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: Text(
                          'CoviSahayata', //TODO: think of app name
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 30.0),
                        child: Text(
                          'Developed by Akshay Jain & Aaditya Bhardwaj',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
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
