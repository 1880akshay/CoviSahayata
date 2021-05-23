import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/bottomNavBar.dart';
import 'package:covid_app/widgets/home.dart';
import 'package:covid_app/widgets/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Profile(),
  ];

  void saveFCMToken(String token) async {
    User _user = FirebaseAuth.instance.currentUser;
    await DatabaseService(uid: _user.uid).saveFCMToken(token);
  }

  void handleToken() async {
    String _fcmToken = await FirebaseMessaging.instance.getToken();
    saveFCMToken(_fcmToken);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveFCMToken);
  }

  @override
  void initState() {
    super.initState();
    handleToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f5),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Add Request',
        color: Colors.grey,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.pushNamed(context, '/addRequest');},
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

