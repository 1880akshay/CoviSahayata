import 'package:covid_app/screens/home/req_listtile.dart';
import 'package:covid_app/screens/models/request.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'req_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class prof_data extends StatefulWidget {
  @override
  _prof_dataState createState() => _prof_dataState();
}

class _prof_dataState extends State<prof_data> {
  FirebaseAuth _auth;
  User _user;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<List<Requests>>(context);
    Requests req;

    return (userdata != null)? ListView.builder(

        itemCount: userdata.length,
        itemBuilder: (context, index) {
          if(userdata[index].uid == _user.uid)
            return req_list(req: userdata[index]);
          else
            return null;
        }
    ): Text('Loading');

  }
}
