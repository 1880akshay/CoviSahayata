import 'package:covid_app/services/auth.dart';
import 'package:covid_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/widgets/signupForm.dart';
import 'package:covid_app/widgets/otpForm.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  String _name='';
  String _number='';
  String _sentCode;

  void addOTPForm(String verificationId, String name, String number) {
    setState(() {
      _sentCode = verificationId;
      _name = name;
      _number = number;
      pageContents.removeLast();
      pageContents.add(OTPForm(verifyOTP: verifyOTP, number: number));
    });
  }

  void addSignupForm() {
    setState(() {
      pageContents.removeLast();
      pageContents.add(SignupForm(getOTP: getOTP));
    });
  }

  void getOTP(String name, String number) async {
    //first check if entry is already in db.
    context.loaderOverlay.show();
    DatabaseReadService dbRead = DatabaseReadService();
    bool isUserAlreadyPresent = await dbRead.doesUserAlreadyExist(number);
    //if not then call api to get otp
    if(isUserAlreadyPresent) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already present!')));
      return;
    }
    AuthServices authService = AuthServices();
    authService.registerSendOTP(context, number, name, addOTPForm, addSignupForm);
  }

  void verifyOTP(String otp) {
    context.loaderOverlay.show();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: _sentCode, smsCode: otp);
    AuthServices authService = AuthServices();
    authService.signUpWithPhoneAuthCredential(phoneAuthCredential, _name, _number, context, addSignupForm);
  }

  List pageContents = [];

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    pageContents = (pageContents.isEmpty) ? <Widget>[
      SizedBox(height: screenHeight*0.09),
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
          'SignUp to Covid App',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SignupForm(getOTP: getOTP),
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

