import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/screens/home/HomeScreen.dart';
import 'package:covid_app/screens/authenticate/authenticate.dart';
//import 'dart:_interceptors';

class form_fill extends StatefulWidget {
  @override
  _form_fillState createState() => _form_fillState();
}

class _form_fillState extends State<form_fill> {
  String _name;
  String _email;
  String _address;
  String _phoneNumber;
  String _request;

  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter Name', hintText: 'Enter your name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        else
          return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildemail() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email', hintText: 'Enter your email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildaddress() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Enter Address',
          hintText: 'Enter the Address where help is needed'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
        else
          return null;
      },
      onSaved: (String value) {
        _address = value;
      },
    );
  }

  Widget _buildphone() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Enter Phone',
          hintText: 'Enter an additional phone number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Additional number is required';
        }
        else
          return null;
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }

  Widget _buildrequest() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Enter the request',
          hintText: 'Enter the help that is needed'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Request is required';
        }
        else
          return null;
      },
      onSaved: (String value) {
        _request = value;
      },
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildName(),
            _buildemail(),
            _buildphone(),
            _buildaddress(),
            _buildrequest(),
            SizedBox(height: 50,),
            ElevatedButton(
              child: Text('Submit', style: TextStyle(
                color: Colors.white, fontSize: 16,),),
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  print('Error');
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saving Data')));
                }
                else {
                  _formKey.currentState.save();
                  print(_name);
                  await DatabaseService(uid: _name + _phoneNumber)
                      .updateRequestData(
                      _name, _email, _phoneNumber, _address, _request,
                      _user.uid);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        return Padding(
          child: form(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
        );
  }
}