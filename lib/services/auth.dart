import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:covid_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {

  FirebaseAuth _auth = FirebaseAuth.instance;

  void signUpWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential, String name, String number, BuildContext context, Function addSignupForm) async {

    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential?.user != null) {
        //enter into database
        User user = authCredential.user;
        await DatabaseService(uid: user.uid).createUser(name, number);
        context.loaderOverlay.hide();
        Navigator.pushReplacementNamed(context, '/home');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed in successfully!')));
    } on FirebaseAuthException catch (e) {
      context.loaderOverlay.hide();
      addSignupForm();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong! Please try again')));
      //print('Something went wrong! Please try again');
    }
  }

  void registerSendOTP(BuildContext context, String number, String name, Function addOTPForm, Function addSignupForm) async {
    context.loaderOverlay.show();
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 0),
      verificationCompleted: (phoneAuthCredential) async {
        signUpWithPhoneAuthCredential(phoneAuthCredential, name, number, context, addSignupForm);
      },
      verificationFailed: (verificationFailed) async {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred! Please try again')));
      },
      codeSent: (verificationId, resendingToken) async {
        context.loaderOverlay.hide();
        addOTPForm(verificationId, name, number);
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void loginWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential, String number, BuildContext context, Function addLoginForm) async {

    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential?.user != null) {
        context.loaderOverlay.hide();
        Navigator.pushReplacementNamed(context, '/home');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed in successfully!')));
    } on FirebaseAuthException catch (e) {
      context.loaderOverlay.hide();
      addLoginForm();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong! Please try again')));
      //print('Something went wrong! Please try again');
    }
  }

  void loginSendOTP(BuildContext context, String number, Function addOTPForm, Function addLoginForm) async {
    context.loaderOverlay.show();
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 0),
      verificationCompleted: (phoneAuthCredential) async {
        loginWithPhoneAuthCredential(phoneAuthCredential, number, context, addLoginForm);
      },
      verificationFailed: (verificationFailed) async {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred! Please try again')));
      },
      codeSent: (verificationId, resendingToken) async {
        context.loaderOverlay.hide();
        addOTPForm(verificationId, number);
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }
}