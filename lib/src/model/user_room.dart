// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserRoom {
  final String displayName;
  final String email;
  final String photoUrl;
  final String uid;

  String alias;
  dynamic userReference;
  bool absent;

  UserRoom(
      {required this.alias,
      required this.displayName,
      required this.email,
      required this.photoUrl,
      required this.uid,
      required this.userReference,
      this.absent = true});

  factory UserRoom.fromFirestore(DocumentSnapshot<Map<String, dynamic>?> doc) {
    final data = doc.data();

    return UserRoom(
        alias: data!["alias"],
        displayName: data["display_name"],
        email: data["email"],
        photoUrl: data["photo_url"],
        uid: data["uid"],
        userReference: data["user_reference"],
        absent: data["absent"] ?? true);
  }

  factory UserRoom.fromMap(Map<String, dynamic> map) => UserRoom(
      alias: map["alias"],
      displayName: map["display_name"],
      email: map["email"],
      photoUrl: map["photo_url"],
      uid: map["uid"],
      userReference: map["user_reference"],
      absent: map["absent"] ?? true);

  factory UserRoom.fromFirebaseAuth(auth.User user) => UserRoom(
      alias: "",
      displayName: user.displayName!,
      email: user.email!,
      photoUrl: user.photoURL!,
      uid: user.uid,
      userReference: "",
      absent: true);

  Map<String, dynamic> toMap() => {
        "alias": alias,
        "display_name": displayName,
        "email": email,
        "photo_url": photoUrl,
        "uid": uid,
        "user_reference": userReference
      };

  Map<String, dynamic> toMapAttendanceUser() => {
        "alias": alias,
        "absent": true,
        "display_name": displayName,
        "email": email,
        "photo_url": photoUrl,
        "uid": uid,
        "user_reference": userReference,
      };

  // set alias
  set setAlias(String newAlias) {
    alias = newAlias;
  }

  // set user reference
  set setUserReference(dynamic newUserReference) {
    userReference = newUserReference;
  }
}
