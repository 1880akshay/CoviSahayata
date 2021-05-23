import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class MyMessages extends StatefulWidget {
  const MyMessages({Key key}) : super(key: key);

  @override
  _MyMessagesState createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {

  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f3f5),
      appBar: AppBar(
        title: Text(
          'My Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: uid).getChatsList,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data.docs.length > 0) ? ListView.separated(
            itemCount: snapshot.data.docs.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 3),
            itemBuilder: (BuildContext context, int index) {
              return ChatListItem(data: snapshot.data.docs[index].data(), uid1: uid);
            },
          ) :
          (snapshot.hasData && snapshot.data.docs.length == 0) ? Center(
            child: Text('No chats yet'),
          ) : (snapshot.hasError) ? Center(
            child: Text('An error occurred'),
          ) : SpinKitCircle(color: Theme.of(context).primaryColor);
        }
      ),
    );
  }
}


class ChatListItem extends StatelessWidget {

  final Map<String, dynamic> data;
  final String uid1;

  const ChatListItem({
    Key key,
    this.data,
    this.uid1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen(uid1: uid1, uid2: data['uid'])));
        },
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: StreamBuilder<UserData>(
              stream: DatabaseService(uid: data['uid']).getProfile,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Initicon(
                      text: (snapshot.hasData) ? snapshot.data.name : '',
                      size: 42,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (snapshot.hasData) ? snapshot.data.name : '',
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.5),
                                  child: Text(
                                    (data['lastMessageBy'] != data['uid']) ? 'You: ${data['lastMessage'].split('\n')[0]}' : data['lastMessage'].split('\n')[0],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(data['lastMessageAt'].seconds * 1000)),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[600],
                        size: 10
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}