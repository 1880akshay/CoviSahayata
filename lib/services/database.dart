import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/user.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference pendingRequests = FirebaseFirestore.instance.collection('pendingRequests');
  final CollectionReference completedRequests = FirebaseFirestore.instance.collection('completedRequests');
  final CollectionReference deletedRequests = FirebaseFirestore.instance.collection('deletedRequests');

  Future<bool> doesUserAlreadyExist(String number) async {
    final QuerySnapshot result = await users
        .where('number', isEqualTo: number)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future createUser(String name, String number) async {
    return await users.doc(uid).set({
      'name' : name,
      'number' : number,
    });
  }

  Future updateName(String newName) async {
    return await users.doc(uid).update({'name': newName});
  }

  Future markAsComplete(String documentId, Map<String, dynamic> requestData) async {
    await pendingRequests.doc(documentId).delete();
    return await completedRequests.add(requestData);
  }

  Future addRequest(List<String> requirements, String state, String district, String secondaryNumber, String primaryNumber) async {
    if(secondaryNumber != '+91') {
      return await pendingRequests.add({
        'state': state,
        'district': district,
        'requirement': requirements,
        'primaryNumber': primaryNumber,
        'secondaryNumber': secondaryNumber,
        'uid': uid,
        'time': Timestamp.now(),
      });
    }
    else {
      return await pendingRequests.add({
        'state': state,
        'district': district,
        'requirement': requirements,
        'primaryNumber': primaryNumber,
        'uid': uid,
        'time': Timestamp.now(),
      });
    }
  }

  Future deleteAccount() async {
    final QuerySnapshot pRequests = await pendingRequests.where('uid', isEqualTo: uid).get();
    final List<DocumentSnapshot> penRequests = pRequests.docs;
    for(var i=0; i<penRequests.length; i++) {
      await deletedRequests.add(penRequests[i].data());
      await pendingRequests.doc(penRequests[i].id).delete();
    }
    final QuerySnapshot cRequests = await completedRequests.where('uid', isEqualTo: uid).get();
    final List<DocumentSnapshot> comRequests = cRequests.docs;
    for(var i=0; i<comRequests.length; i++) {
      await deletedRequests.add(comRequests[i].data());
      await completedRequests.doc(comRequests[i].id).delete();
    }
    return await users.doc(uid).delete();
  }

  //testing function
  // Future markAsPending(String documentId, Map<String, dynamic> requestData) async {
  //   await completedRequests.doc(documentId).delete();
  //   return await pendingRequests.add(requestData);
  // }

  UserData _getUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      number: snapshot.data()['number'],
    );
  }

  Stream<UserData> get getProfile {
    return users.doc(uid).snapshots()
      .map(_getUserDataFromSnapshot);
  }

  // Stream<QuerySnapshot> get getRequestsPrev {
  //   return pendingRequests
  //     .orderBy('time', descending: true)
  //     .snapshots();
  // }

  Future<QuerySnapshot> get getRequests {
    return pendingRequests
      .orderBy('time', descending: true)
      .get();
  }
  
  Future<QuerySnapshot> getRequestsWithRequirementFilter(List<String> requirements) {
    return pendingRequests
      .where('requirement', arrayContainsAny: requirements)
      .orderBy('time', descending: true)
      .get();
  }

  Future<QuerySnapshot> getRequestsWithStateFilter(List<String> states) {
    return pendingRequests
      .where('state', whereIn: states)
      .orderBy('time', descending: true)
      .get();
  }

  Stream<QuerySnapshot> get getIndividualPendingRequests {
    return pendingRequests
      .where('uid', isEqualTo: uid)
      .orderBy('time', descending: true)
      .snapshots();
  }

  Stream<QuerySnapshot> get getIndividualCompletedRequests {
    return completedRequests
      .where('uid', isEqualTo: uid)
      .orderBy('time', descending: true)
      .snapshots();
  }

}

