import 'package:covid_app/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either Home or authenticate widget
    return Container(
      child: Authenticate(),
    );
  }
}
