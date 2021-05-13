import 'package:flutter/material.dart';

class ProfilePageButton extends StatelessWidget {

  final String title;
  final String subTitle;
  final dynamic icon;
  final Function onTap;

  const ProfilePageButton({
    Key key,
    this.title,
    this.subTitle,
    this.icon,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        subTitle,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11.0
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
            ),
          ),
        ),
      ),
    );
  }
}