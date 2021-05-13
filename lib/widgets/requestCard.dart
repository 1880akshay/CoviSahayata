import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> requestData;
  const RequestCard({Key key, this.requestData}) : super(key: key);

  _makePhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    DateTime dateTimeData = DateTime.fromMillisecondsSinceEpoch(requestData['time'].seconds * 1000);
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
                            '${requestData['requirement'].join(', ')} required in ${requestData['district']}, ${requestData['state']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.grey[850],
                            ),
                          ),
                          SizedBox(height: 1),
                          StreamBuilder<UserData>(
                            stream: DatabaseService(uid: requestData['uid']).getProfile,
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
                      onPressed: () {_makePhoneCall(requestData['primaryNumber']);},
                      icon: Icon(
                        Icons.phone,
                        color: Colors.grey[850],
                        size: 18,
                      ),
                      label: Text(
                        requestData['primaryNumber'],
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  (requestData.containsKey('secondaryNumber')) ? Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      onPressed: () {_makePhoneCall(requestData['secondaryNumber']);},
                      icon: Icon(
                        Icons.phone,
                        color: Colors.grey[850],
                        size: 18,
                      ),
                      label: Text(
                        requestData['secondaryNumber'],
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
