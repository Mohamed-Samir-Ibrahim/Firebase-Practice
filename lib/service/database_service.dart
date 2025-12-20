import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/model/brew_model.dart';
import 'package:firebase_practice/model/user_model.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  CollectionReference<Map<String, dynamic>> firebaseFirestore =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugar, String name, int strength) async {
    return await firebaseFirestore.doc(uid).set({
      'sugar': sugar,
      'name': name,
      'strength': strength,
    });
  }

  List<BrewModel> brewsList(QuerySnapshot snapshot) {
    return snapshot.docChanges.map((doc) {
      return BrewModel(
        name: doc.doc['name'] ?? 'New Crew User',
        strength: doc.doc['strength'] ?? 0,
        sugar: doc.doc['sugar'] ?? '100',
      );
    }).toList();
  }

  Stream<List<BrewModel>> get brew {
    return firebaseFirestore.snapshots().map(brewsList);
  }

  UserData userDataFromSnapshot(DocumentSnapshot snapShot) {
    return UserData(
      uid: uid,
      name: snapShot['name'],
      sugar: snapShot['sugar'],
      strength: snapShot['strength'],
    );
  }

  Stream<UserData> get userData {
    return firebaseFirestore.doc(uid).snapshots().map(userDataFromSnapshot);
  }
}
