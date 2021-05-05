import 'package:covid_app/screens/models/request.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/database.dart';
import 'package:provider/provider.dart';
import 'data.dart';
 class profile extends StatefulWidget {
   @override
   _profileState createState() => _profileState();
 }

 class _profileState extends State<profile> {
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
