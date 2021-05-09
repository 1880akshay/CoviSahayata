import 'package:covid_app/screens/models/request.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'req_tile.dart';

class data extends StatefulWidget {
  @override
  _dataState createState() => _dataState();
}

class _dataState extends State<data> {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<List<Requests>>(context);
    Requests req;

    return (userdata != null) ? ListView.builder(

        itemCount: userdata.length,
      itemBuilder: (context, index) {
          if(userdata[index].status == "I")
    return reqtile(req: userdata[index]);
          else
            return null;
    }
    ) : Text("Loading");

  }
}
