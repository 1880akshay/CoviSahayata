import 'package:covid_app/screens/home/prof_data.dart';
import 'package:covid_app/screens/home/req_listtile.dart';
import 'package:covid_app/screens/models/request.dart';
import 'package:covid_app/screens/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/database.dart';
import 'package:provider/provider.dart';
import 'data.dart';
 class profile extends StatefulWidget {
   @override
   _profileState createState() => _profileState();
 }

 class _profileState extends State<profile> {
   FirebaseAuth _auth;
   User _user;

   @override
   void initState() {
     super.initState();
     _auth = FirebaseAuth.instance;
     _user = _auth.currentUser;
   }
   Widget prof_display() {
     return StreamBuilder<UserData>(
         stream: DatabaseService(uid: _user.uid).userdata,
         builder: (context, snapshot) {

             UserData userdata = snapshot.data;
               return Scaffold(
               backgroundColor: Colors.blue[100],
               body: Container(
                 child: Center(
                   child: Text(
                       'Name is ${userdata.name} and phone is ${userdata.phone}'),
                 ),
               ),
             );
           }
     );
   }

   Widget req_display() {
     return StreamProvider<List<Requests>>.value(
       value: DatabaseService().data,
       child: Scaffold(
         backgroundColor: Colors.amber,
         body: prof_data(),
       ),
     );
   }

   @override
   Widget build(BuildContext context) {
     //final user = Provider.of<User>(context);
     return StreamProvider<List<Requests>>.value(
       value: DatabaseService().data,
       child: Scaffold(
         backgroundColor: Colors.amber,
         body: prof_data(),
       ),
     );
     return Scaffold(
         body: Container(
           height: 200,
         margin: EdgeInsets.all(24),
            child:Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               //prof_display(),
               req_display(),
       ],
     ),
         )
     );
     return StreamBuilder<UserData>(
       stream: DatabaseService(uid: _user.uid).userdata,
       builder: (context, snapshot) {
         if (snapshot.hasData) {
           UserData userdata = snapshot.data;
           return Scaffold(
             backgroundColor: Colors.blue[100],
             body: Container(
               child: Center(
                 child: Text(
                     'Name is ${userdata.name} and phone is ${userdata.phone}'),
               ),
             ),
           );
         }
         return Scaffold(
           body: Container(
             child: Center(
               child: Text('No data'),
             ),
           ),
         );
       },
     );
   }
 }



