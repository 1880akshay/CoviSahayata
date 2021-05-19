import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatefulWidget {
  final Map<String, dynamic> requestData;
  final String uid1;
  const RequestCard({Key key, this.requestData, this.uid1}) : super(key: key);

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  _makePhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showPhoneDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(25, 20, 25, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Call',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.close,
                  size: 18,
                ),
                onTap: () {Navigator.of(context).pop();},
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _makePhoneCall(widget.requestData['primaryNumber']);
                    },
                    icon: Icon(
                      Icons.call,
                      size: 18,
                      color: Colors.grey[850],
                    ),
                    label: Text(
                      widget.requestData['primaryNumber'],
                      style: TextStyle(
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                ),
                if(widget.requestData.containsKey('secondaryNumber'))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _makePhoneCall(widget.requestData['secondaryNumber']);
                      },
                      icon: Icon(
                        Icons.call,
                        size: 18,
                        color: Colors.grey[850],
                      ),
                      label: Text(
                        widget.requestData['secondaryNumber'],
                        style: TextStyle(
                          color: Colors.grey[850],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    DateTime dateTimeData = DateTime.fromMillisecondsSinceEpoch(widget.requestData['time'].seconds * 1000);
    String date = DateFormat.yMMMMd('en_US').format(dateTimeData);

    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        child: Container(
          //color: Colors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.requestData['requirement'].join(', ')} required in ${widget.requestData['district']}, ${widget.requestData['state']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.grey[850],
                            ),
                          ),
                          SizedBox(height: 1),
                          StreamBuilder<UserData>(
                            stream: DatabaseService(uid: widget.requestData['uid']).getProfile,
                            builder: (context, snapshot) {
                              return Text(
                                (snapshot.data != null) ? '- ${snapshot.data.name}' : '',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                    ActionChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        date,
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      backgroundColor: Colors.green[100],
                      labelStyle: TextStyle(
                        color: Colors.green[900]
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Divider(height: 2.0, color: Colors.grey[350],),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      //onPressed: () {_makePhoneCall(requestData['primaryNumber']);},
                      onPressed: () {
                        if(widget.uid1 != widget.requestData['uid']) {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen(uid1: widget.uid1, uid2: widget.requestData['uid'])));
                        }
                      },
                      icon: Icon(
                        Icons.message,
                        color: Colors.grey[850],
                        size: 18,
                      ),
                      label: Text(
                        'Message',
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      onPressed: () async {
                        //_makePhoneCall(widget.requestData['primaryNumber']);
                        await _showPhoneDialog();
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.grey[850],
                        size: 18,
                      ),
                      label: Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
