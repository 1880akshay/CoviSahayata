import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {

  final Function getOTP;
  SignupForm({ Key key, this.getOTP }): super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {

  final _signupFormKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _numberKey = GlobalKey<FormFieldState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();

  String name='';
  String number='';

  void submitSignup() {
    FocusScope.of(context).unfocus();
    if (_signupFormKey.currentState.validate()) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      widget.getOTP(name, '+91'+number);
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
          key: _signupFormKey,
          child: Column(
            children: [
              TextFormField(
                key: _nameKey,
                focusNode: _nameFocus,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if(value==null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nameKey.currentState.validate();
                  setState(() {
                    name=value;
                  });
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  _nameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_numberFocus);
                },
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
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.person, size: 20),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                key: _numberKey,
                focusNode: _numberFocus,
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
                  _numberKey.currentState.validate();
                  setState(() {
                    number=value;
                  });
                },
                onFieldSubmitted: (value) {
                  submitSignup();
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
                  prefixIcon: Icon(Icons.phone_android, size: 20),
                  prefixText: '+91 ',
                  prefixStyle: TextStyle(
                    fontSize: 14,
                  )
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitSignup,
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
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushReplacementNamed(context, '/login');
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
