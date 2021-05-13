import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {

  final Function getOTP;
  LoginForm({ Key key, this.getOTP }): super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _loginFormKey = GlobalKey<FormState>();

  String number='';

  void submitLogin() {
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState.validate()) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      widget.getOTP('+91'+number);
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
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if(value==null || value.isEmpty) {
                    return 'Phone Number cannot be empty';
                  }
                  String regex = '^[0-9]*\$';
                  RegExp regExp = new RegExp(regex);
                  if(regExp.hasMatch(value)) return null;
                  return 'Invalid Phone number';
                },
                onChanged: (value) {
                  _loginFormKey.currentState.validate();
                  setState(() {
                    number=value;
                  });
                },
                onFieldSubmitted: (value) {
                  submitLogin();
                },
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[850],
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6),
                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.phone_android,
                    size: 20,
                  ),
                  prefixText: '+91 ',
                  prefixStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitLogin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Send OTP',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'New to Covid App? ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Signup',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
