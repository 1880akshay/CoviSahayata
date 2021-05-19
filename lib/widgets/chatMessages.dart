import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageSelf extends StatefulWidget {
  final Map<String, dynamic> messageData;
  const ChatMessageSelf({Key key, this.messageData}) : super(key: key);

  @override
  _ChatMessageSelfState createState() => _ChatMessageSelfState();
}

class _ChatMessageSelfState extends State<ChatMessageSelf> {

  @override
  Widget build(BuildContext context) {

    DateTime dateTimeData = DateTime.fromMillisecondsSinceEpoch(widget.messageData['sentAt'].seconds * 1000);
    String time = DateFormat.jm().format(dateTimeData);

    return Bubble(
      margin: BubbleEdges.only(left: 50),
      alignment: Alignment.topRight,
      padding: BubbleEdges.symmetric(vertical: 7, horizontal: 10),
      color: Theme.of(context).primaryColorLight,
      nip: BubbleNip.rightTop,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.messageData['message'],
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageOther extends StatefulWidget {
  final Map<String, dynamic> messageData;
  const ChatMessageOther({Key key, this.messageData}) : super(key: key);

  @override
  _ChatMessageOtherState createState() => _ChatMessageOtherState();
}

class _ChatMessageOtherState extends State<ChatMessageOther> {
  @override
  Widget build(BuildContext context) {

    DateTime dateTimeData = DateTime.fromMillisecondsSinceEpoch(widget.messageData['sentAt'].seconds * 1000);
    String time = DateFormat.jm().format(dateTimeData);

    return Bubble(
      margin: BubbleEdges.only(right: 50),
      alignment: Alignment.topLeft,
      padding: BubbleEdges.symmetric(vertical: 7, horizontal: 10),
      color: Colors.white,
      nip: BubbleNip.leftTop,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.messageData['message'],
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 10),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}



