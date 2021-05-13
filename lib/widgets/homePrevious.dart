import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/requestCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            elevation: 3.0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                //color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Theme.of(context).primaryColor.withOpacity(1.0), BlendMode.softLight),
                  image: AssetImage('assets/images/headbg.png'),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: Ink(
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.black12,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.filter_alt_outlined),
                              color: Colors.white,
                              iconSize: 22,
                              tooltip: 'Filter',
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: DatabaseService().getRequestsPrev,
              builder: (context, snapshot) {
                //if(snapshot.hasData) print(snapshot.data.docs[0].data());
                return Container(
                  height: screenHeight - 260,
                  child: (snapshot.hasData && snapshot.data.docs.length > 0) ? ListView.builder(
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
                        'No requests available',
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
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
