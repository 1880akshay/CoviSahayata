import 'package:covid_app/screens/authenticate/sign_in.dart';
import 'package:covid_app/screens/home/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/authenticate/sign_in.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'fab_bottom_nav.dart';
import 'layout.dart';
import 'fabwithicon.dart';
import 'profile.dart';
import 'home.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    profile(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();


  final _auth = FirebaseAuth.instance;
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      currentTab = index;
      currentScreen = screens[index];
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  void _showform() {
    showModalBottomSheet(context: context, builder: (context){
      return form_fill();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF8EBC5),
      body: HomeScreen(),
      resizeToAvoidBottomInset: true,
      //body: PageStorage(
      //child: currentScreen,
      //bucket: bucket,
      //),
      /*body: Center(
          child: Text('Welcome to Covid App'),
        ),*/
      /* bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue[300],
        backgroundColor: Color(0xFFF8EBC5),
        height: 50,
        items: <Widget>[
          Icon(Icons.verified_user, size:30, color: Colors.black,),
          Icon(Icons.add, size:35, color: Colors.black),
          Icon(Icons.list, size:30, color: Colors.black),
        ],
        animationDuration: Duration(
          milliseconds: 200,
        ),
        animationCurve: Curves.bounceInOut,
        onTap: (index){
          print(index);
        },
      ),*/
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Add Request',
        backgroundColor: Colors.white,
        color: Colors.black,
        selectedColor: Color(0xFFF8EBC5),
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        iconSize: 20,
        height: 60,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () =>{  _showform()

         // Navigator.push(
           //   context, MaterialPageRoute(builder: (context) => form_fill()));

       },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),

    );
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton:
    FloatingActionButton(
      onPressed: () async {
        await _auth.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Icon(Icons.logout),

      //  )
    );
  }
}
/*Widget _buildFab(BuildContext context) {
  //final icons = [ Icons.sms, Icons.mail, Icons.phone ];
  return AnchoredOverlay(
    //showOverlay: true,

    child: FloatingActionButton(
      backgroundColor: Colors.blue[300],
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> form_fill()));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 2.0,
    ),
  );
}
}*/
