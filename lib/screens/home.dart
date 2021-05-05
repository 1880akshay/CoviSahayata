import 'package:flutter/material.dart';
import 'package:covid_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth;
  User _currentUser;
  dynamic profile;

  dynamic getProfile() async {
    return await DatabaseService(uid: _currentUser.uid).getProfile();
  }

  @override
  void initState() {
    //profile = getProfile();
    _auth = FirebaseAuth.instance;
    _currentUser = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Center(
                child: (profile != null) ? SpinKitRing(
                  color: Theme.of(context).primaryColor,
                ) :
                Column(
                  children: [
                    Text(_currentUser.uid),
                    //Text(profile['name']),
                    ElevatedButton(
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Logout'),
                    )
                  ],
                )
            ),
          )
      ),
    );
  }
}

