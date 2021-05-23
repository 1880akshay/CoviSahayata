import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/chatMessages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String uid1;
  final String uid2;
  const ChatScreen({Key key, this.uid1, this.uid2}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserData secondUser;
  TextEditingController messageController = TextEditingController();
  bool positiveMessages = false;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f3f5),
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        title: StreamBuilder<UserData>(
            stream: DatabaseService(uid: widget.uid2).getProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) secondUser = snapshot.data;

              return Row(
                children: [
                  Initicon(
                    text: (secondUser != null) ? secondUser.name : '',
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    (secondUser != null) ? secondUser.name : '',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              );
            }),
      ),
      body: Builder(builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        DatabaseService().getMessages(widget.uid1, widget.uid2),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.docs.length > 0)
                        positiveMessages = true;
                      else
                        positiveMessages = false;
                      return (snapshot.hasData && snapshot.data.docs.length > 0)
                          ? ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool showDate = false;
                                String date1 = DateFormat.yMMMMd('en_US')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data.docs[index]
                                                .data()['sentAt']
                                                .seconds *
                                            1000));
                                String date2;
                                if (index == snapshot.data.docs.length - 1)
                                  showDate = true;
                                else {
                                  date2 = DateFormat.yMMMMd('en_US').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data.docs[index + 1]
                                                  .data()['sentAt']
                                                  .seconds *
                                              1000));
                                  if (date1 != date2) showDate = true;
                                }

                                if (snapshot.data.docs[index]
                                        .data()['sentBy'] ==
                                    widget.uid1) {
                                  if (showDate) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Center(
                                            child: Text(
                                              date1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: ChatMessageSelf(
                                              messageData: snapshot
                                                  .data.docs[index]
                                                  .data()),
                                        ),
                                      ],
                                    );
                                  }
                                  return Padding(
                                    padding: (index ==
                                            snapshot.data.docs.length - 1)
                                        ? EdgeInsets.symmetric(vertical: 5)
                                        : (snapshot.data.docs[index + 1]
                                                    .data()['sentBy'] ==
                                                widget.uid1)
                                            ? EdgeInsets.only(bottom: 5)
                                            : EdgeInsets.symmetric(vertical: 5),
                                    child: ChatMessageSelf(
                                        messageData:
                                            snapshot.data.docs[index].data()),
                                  );
                                } else {
                                  if (showDate) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Center(
                                            child: Text(
                                              date1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: ChatMessageOther(
                                              messageData: snapshot
                                                  .data.docs[index]
                                                  .data()),
                                        ),
                                      ],
                                    );
                                  }
                                  return Padding(
                                    padding: (index ==
                                            snapshot.data.docs.length - 1)
                                        ? EdgeInsets.symmetric(vertical: 5)
                                        : (snapshot.data.docs[index + 1]
                                                    .data()['sentBy'] ==
                                                widget.uid2)
                                            ? EdgeInsets.only(bottom: 5)
                                            : EdgeInsets.symmetric(vertical: 5),
                                    child: ChatMessageOther(
                                        messageData:
                                            snapshot.data.docs[index].data()),
                                  );
                                }
                              },
                            )
                          : (snapshot.hasData)
                              ? Center(child: Text('No messages yet'))
                              : (snapshot.hasError)
                                  ? Center(
                                      child: Text('An error occurred'),
                                    )
                                  : SpinKitCircle(
                                      color: Theme.of(context).primaryColor);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          elevation: 1,
                          child: TextField(
                            controller: messageController,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 500,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              hintText: 'Type your message',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Material(
                      elevation: 1,
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: Ink(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(9),
                          icon: Icon(Icons.send_sharp),
                          color: Colors.white,
                          iconSize: 20,
                          tooltip: 'Send',
                          onPressed: () {
                            if (messageController.text != '') {
                              if (positiveMessages)
                                _scrollController.animateTo(
                                    _scrollController.position.minScrollExtent,
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut);
                              DatabaseService().addMessage(
                                  messageController.text,
                                  widget.uid1,
                                  widget.uid2);
                              messageController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
