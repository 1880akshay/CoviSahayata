import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/user.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference pendingRequests = FirebaseFirestore.instance.collection('pendingRequests');
  final CollectionReference completedRequests = FirebaseFirestore.instance.collection('completedRequests');

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
  
  Stream<QuerySnapshot> get getChatsList {
    return users.doc(uid).collection('chatsWith')
      .orderBy('lastMessageAt', descending: true)
      .snapshots();
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

  Stream<QuerySnapshot> getMessages(String uid1, String uid2) {
    int temp = uid1.compareTo(uid2);
    String docId;
    if(temp==-1) {
      docId = uid1+uid2;
    }
    else {
      docId = uid2+uid1;
    }
    final CollectionReference messages = FirebaseFirestore.instance.collection('chats').doc(docId).collection('messages');
    return messages
      .orderBy('sentAt', descending: true)
      .snapshots();
  }

  Future addMessage(String message, String uid1, String uid2) async {
    int temp = uid1.compareTo(uid2);
    String docId;
    if(temp==-1) {
      docId = uid1+uid2;
    }
    else {
      docId = uid2+uid1;
    }
    final CollectionReference messages = FirebaseFirestore.instance.collection('chats').doc(docId).collection('messages');
    final CollectionReference sender = FirebaseFirestore.instance.collection('users').doc(uid1).collection('chatsWith');
    final CollectionReference receiver = FirebaseFirestore.instance.collection('users').doc(uid2).collection('chatsWith');

    Timestamp time = Timestamp.now();

    sender.doc(uid2).set({
      "uid": uid2,
      "lastMessageAt": time,
    });

    receiver.doc(uid1).set({
      "uid": uid1,
      "lastMessageAt": time,
    });

    return await messages.add({
      'sentBy': uid1,
      'sentAt': time,
      'message': message,
    });
  }

}

