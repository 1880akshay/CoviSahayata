import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginFormKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _numberKey = GlobalKey<FormFieldState>();

  String name='';
  String number='';

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

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
                  children: [
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
                        'Login to Covid App',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
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
                                key: _nameKey,
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black26),
                                  ),
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                key: _numberKey,
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
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black26),
                                  ),
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Icons.phone_android),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_loginFormKey.currentState.validate()) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 13.0),
                                        child: Text(
                                          'Get OTP',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

