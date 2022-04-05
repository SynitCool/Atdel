// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user.dart' as model;

class CurrentUser extends ChangeNotifier {
  model.User? user;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  final String rootUsersCollection = "users";

  // get auth user
  Future setCurrentAuthUser() async {
    // get current user
    final auth.User? firebaseUser = _auth.currentUser;

    user = model.User.fromFirebaseAuth(firebaseUser!);
  }

  // get firestore user
  Future setFirestoreUser() async {
    // auth user
    final auth.User? firebaseUser = _auth.currentUser;

    // get firestore user
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> doc =
        collection.doc(firebaseUser!.uid);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    // set current user
    user = model.User.fromFirestore(getDoc);
  }

  // set user
  set setUser(model.User? newUser) {
    user = newUser;
    notifyListeners();
  }
}
