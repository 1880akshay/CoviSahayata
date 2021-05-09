import 'package:covid_app/screens/models/request.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/database.dart';
import 'package:provider/provider.dart';
import 'data.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Requests>>.value(
      value: DatabaseService().data,
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: data(),
      ),
    );
  }
}


/*class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8EBC5),
      body: Center(
        child: Text('Welcome to Covid App'),
      ),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Icon(Icons.logout),

    )
    );
  }
}*/
