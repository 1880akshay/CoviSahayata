import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/screens/models/request.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference user_data = FirebaseFirestore.instance.collection('Users');
  final CollectionReference user_request = FirebaseFirestore.instance.collection('Requests');

  Future updateUserData(String name, String number) async {
    return await user_data.doc(uid).set({
      'name' : name,
      'phone' : number,
    });
  }

  Future updateRequestData(String name, String email, String number1, String Address, String request) async {
    return await user_request.doc(uid).set({
      'name' : name,
      'email' : email,
      'addphone' : number1,
      'address' : Address,
      'request' : request,
    });
  }

  //get stream
List<Requests> _requestlistfromsnap(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
        return Requests(
          name: doc.data()['name'].toString() ?? "",
          email: doc.data()['email'].toString() ?? "",
          address: doc.data()['address'].toString() ?? "",
          request: doc.data()['request'].toString() ?? "",
          phone: doc.data()['addphone'].toString() ?? "",
        );
    }).toList();
}
Stream<List<Requests>> get data {
    return user_request.snapshots().map(_requestlistfromsnap);
}

}

