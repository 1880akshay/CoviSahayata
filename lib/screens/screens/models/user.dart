import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String uid;
  final String name;
  final String phone;
  UserData({this.uid, this.name, this.phone});
}