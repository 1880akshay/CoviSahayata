import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPForm extends StatefulWidget {

  final Function verifyOTP;
  final Function resendOTP;
  OTPForm({ Key key, this.verifyOTP, this.resendOTP }): super(key: key);

  @override
  _OTPFormState createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {

  final _otpFormKey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;

  String otp='';

  void submitOTP() {
    FocusScope.of(context).unfocus();
    if(otp.length!=6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP must have 6 digits')));
      return;
    }
    if (_otpFormKey.currentState.validate()) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      widget.verifyOTP(otp);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(3.0, 3.0), spreadRadius: 3.0, blurRadius: 5.0),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        child: Form(
          key: _otpFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OTP',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Didn\'t receive OTP? ',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Resend OTP',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              //Navigator.pushReplacementNamed(context, '/login');
                              //call for resend otp api
                              widget.resendOTP();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                validator: (value) {
                  if(value==null || value.isEmpty) {
                    return 'OTP cannot be empty';
                  }
                  String regex = '^[0-9]*\$';
                  RegExp regExp = new RegExp(regex);
                  if(regExp.hasMatch(value)) return null;
                  return 'Invalid OTP';
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeColor: Colors.black38,
                  selectedColor: Colors.black87,
                  inactiveColor: Colors.black38,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                textStyle: TextStyle(fontSize: 20, height: 1.6),
                enableActiveFill: false,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: false,
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                onSubmitted: (value) {
                  submitOTP();
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitOTP,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13.0),
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                              fontSize: 16.0
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).primaryColor.withOpacity(0.7);
                            return Theme.of(context).primaryColor;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
