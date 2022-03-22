import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:atdel/src/databases/firebase_firestore.dart' as model;

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    await addToDatabase();

    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future addToDatabase() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    final String firebaseUserUid = firebaseUser!.uid;
    final String? firebaseUserDisplayName = firebaseUser.displayName;
    final String? firebaseUserEmail = firebaseUser.email;
    final String? firebaseUserPhotoUrl = firebaseUser.photoURL;
    final bool firebaseUserIsAnonymous = firebaseUser.isAnonymous;

    final Map<String, dynamic> firebaseUserInfo = {
      "uid": firebaseUserUid,
      "diplay_name": firebaseUserDisplayName,
      "email": firebaseUserEmail,
      "photo_url": firebaseUserPhotoUrl,
      "is_anonymous": firebaseUserIsAnonymous
    };

    final List<String> rooms = [];

    final model.User userModel =
        model.User(uid: firebaseUserUid, info: firebaseUserInfo, rooms: rooms);

    userModel.toJson();

    userModel.createAccount();
  }
}
