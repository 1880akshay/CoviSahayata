import 'package:covid_app/widgets/otpForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/widgets/loginForm.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _number='';
  String _sentCode;

  void addOTPForm(String verificationId, String number) {
    setState(() {
      _sentCode = verificationId;
      _number = number;
      pageContents.removeLast();
      pageContents.add(OTPForm(verifyOTP: verifyOTP, number: number));
    });
  }

  void addLoginForm() {
    setState(() {
      pageContents.removeLast();
      pageContents.add(LoginForm(getOTP: getOTP));
    });
  }

  void getOTP(String number) async {
    //first check if entry is already in db.
    context.loaderOverlay.show();
    DatabaseService dbRead = DatabaseService();
    bool isUserAlreadyPresent = await dbRead.doesUserAlreadyExist(number);
    //if yes then call api to get otp
    if(!isUserAlreadyPresent) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No such user exists!')));
      return;
    }
    AuthServices authService = AuthServices();
    authService.loginSendOTP(context, number, addOTPForm, addLoginForm);
  }

  void verifyOTP(String otp) {
    context.loaderOverlay.show();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: _sentCode, smsCode: otp);
    AuthServices authService = AuthServices();
    authService.loginWithPhoneAuthCredential(phoneAuthCredential, _number, context, addLoginForm);
  }

  List pageContents = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    pageContents = (pageContents.isEmpty) ? <Widget>[
      SizedBox(height: screenHeight*0.1),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: Image.asset('assets/images/icon.png'),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          'Login to Covid App',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      LoginForm(getOTP: getOTP),
    ] : pageContents;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageContents,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
