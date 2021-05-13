import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPForm extends StatefulWidget {

  final Function verifyOTP;
  final String number;
  OTPForm({ Key key, this.verifyOTP, this.number }): super(key: key);

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
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'OpenSans',
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(text: 'A One Time Password (OTP) has been sent to your mobile '),
                      TextSpan(text: '${widget.number}', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '. Please enter the OTP here:'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'OTP',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.grey[850],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 45,
                  fieldWidth: 45,
                  activeColor: Colors.black26,
                  selectedColor: Colors.grey[850],
                  inactiveColor: Colors.black26,
                ),
                cursorColor: Colors.grey[850],
                cursorHeight: 20,
                animationDuration: Duration(milliseconds: 100),
                textStyle: TextStyle(fontSize: 16, height: 1, fontWeight: FontWeight.w600, color: Colors.grey[850]),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitOTP,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                              fontSize: 15.0
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
