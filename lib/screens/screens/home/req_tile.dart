import 'package:covid_app/screens/models/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class reqtile extends StatelessWidget {
  final Requests req;
  reqtile({this.req});
  _showmodal(BuildContext context)
  {
    return showDialog(context: context, builder: (context){
      return Dialog(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(20.0)),
         child: Column(
         ,
       ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),

          child: ListTile(

            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.blue[300],
            ),
            title: Text('${req.name}, ${req.address}'),
            subtitle: Text(req.request),
            onTap: () {
              _showmodal(context);
            },

          ),
        ),

    );
  }
}

