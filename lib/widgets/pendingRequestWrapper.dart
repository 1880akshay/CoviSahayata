import 'package:covid_app/services/database.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:covid_app/widgets/requestCard.dart';
import 'package:flutter/material.dart';

class PendingRequestWrapper extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String documentId;
  final BuildContext scaffoldContext;
  const PendingRequestWrapper({Key key, this.requestData, this.documentId, this.scaffoldContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> _showConfirmationDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Mark as Complete',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to mark this request as complete?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  scaffoldContext.loaderOverlay.show();
                  try {
                    await DatabaseService().markAsComplete(documentId, requestData);
                    scaffoldContext.loaderOverlay.hide();
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(content: Text('Request marked as complete!'), behavior: SnackBarBehavior.floating,));
                  } catch(e) {
                    scaffoldContext.loaderOverlay.hide();
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(content: Text('Something went wrong! Please try again')));
                  }
                },
              ),
            ],
          );
        },
      );
    }

    void markAsComplete() async {
      await _showConfirmationDialog();
    }

    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: TextButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10)),
                  backgroundColor: MaterialStateProperty.all(Colors.green[100]),
                ),
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green[900],
                  size: 18,
                ),
                label: Text(
                  'Mark as complete',
                  style: TextStyle(
                    color: Colors.green[900],
                    fontSize: 12,
                  ),
                ), onPressed: markAsComplete,
              ),
            ),
          ),
          RequestCard(requestData: requestData),
        ],
      ),
    );
  }
}
