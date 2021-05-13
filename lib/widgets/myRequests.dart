import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/pendingRequestWrapper.dart';
import 'package:covid_app/widgets/requestCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyRequests extends StatefulWidget {

  final String uid;

  const MyRequests({Key key, this.uid}) : super(key: key);

  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {

  final GlobalKey<ScaffoldState> _myRequestsScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _myRequestsScaffoldKey,
      backgroundColor: Color(0xfff2f3f5),
      appBar: AppBar(
        title: Text(
          'My Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'Pending Requests',
              style: TextStyle(
                color: Colors.grey[850],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder(
            stream: DatabaseService(uid: widget.uid).getIndividualPendingRequests,
            builder: (context, snapshot) {
              return (snapshot.hasData && snapshot.data.docs.length > 0) ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return PendingRequestWrapper(
                    requestData: snapshot.data.docs[index].data(),
                    documentId: snapshot.data.docs[index].id,
                    scaffoldContext: _myRequestsScaffoldKey.currentContext,
                  );
                }
              ) : (snapshot.hasData && snapshot.data.docs.length == 0) ?
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No pending requests',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 15,
                    ),
                  ),
                ),
              ) : (snapshot.hasError) ?
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'An error occurred',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 15,
                    ),
                  ),
                ),
              ) :
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: PlaceholderLines(
                    count: 3,
                    animate: true,
                  ),
                ),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 10, color: Colors.grey[850]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'Completed Requests',
              style: TextStyle(
                color: Colors.grey[850],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder(
              stream: DatabaseService(uid: widget.uid).getIndividualCompletedRequests,
              builder: (context, snapshot) {
                return (snapshot.hasData && snapshot.data.docs.length > 0) ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RequestCard(
                        requestData: snapshot.data.docs[index].data(),
                      );
                    }
                ) : (snapshot.hasData && snapshot.data.docs.length == 0) ?
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No completed requests',
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ) : (snapshot.hasError) ?
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'An error occurred',
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ) :
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: PlaceholderLines(
                      count: 3,
                      animate: true,
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
