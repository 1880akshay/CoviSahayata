import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference user_data = FirebaseFirestore.instance.collection('Users');

  Future updateUserData(String name, String number) async {
    return await user_data.doc(uid).set({
      'name' : name,
      'phone' : number,
    });
  }
}