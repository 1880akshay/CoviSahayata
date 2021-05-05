import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future createUser(String name, String number) async {
    return await users.doc(uid).set({
      'name' : name,
      'number' : number,
    });
  }

  Future getProfile() async {
    final DocumentSnapshot result = await users.doc(uid).get();
    return result.data();
  }

}

class DatabaseReadService {

  Future<bool> doesUserAlreadyExist(String number) async {
    final QuerySnapshot result = await firestore
        .collection('users')
        .where('number', isEqualTo: number)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
