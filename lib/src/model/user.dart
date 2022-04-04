// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String displayName;
  final String email;
  final bool isAnonymous;
  final String photoUrl;
  final String uid;

  bool absent;
  dynamic userReference;
  List<dynamic> roomReferences;

  User(
      {required this.displayName,
      required this.email,
      required this.isAnonymous,
      required this.photoUrl,
      required this.uid,
      required this.roomReferences,
      required this.absent,
      required this.userReference});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    return User(
        displayName: data!["display_name"],
        email: data["email"],
        isAnonymous: data["is_anonymous"],
        photoUrl: data["photo_url"],
        uid: data["uid"],
        roomReferences: data["room_references"],
        absent: true,
        userReference: data["user_reference"]);
  }

  factory User.fromFirebaseAuth(auth.User authUser) {
    return User(
        displayName: authUser.displayName!,
        email: authUser.email!,
        isAnonymous: authUser.isAnonymous,
        photoUrl: authUser.photoURL!,
        uid: authUser.uid,
        roomReferences: [],
        absent: true,
        userReference: "");
  }

  factory User.fromMap(Map<String, dynamic> map) => User(
      displayName: map["display_name"],
      email: map["email"],
      isAnonymous: map["is_anonymous"],
      photoUrl: map["photo_url"],
      uid: map["uid"],
      roomReferences: map["room_references"] ?? [],
      absent: map["absent"] ?? true,
      userReference: map["user_reference"]);

  Map<String, dynamic> toMapUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid,
        "room_references": roomReferences.toSet().toList(),
        "user_reference": userReference
      };

  Map<String, dynamic> toMapRoomUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid,
        "user_reference": userReference
      };

  Map<String, dynamic> toMapAttendanceUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid,
        "absent": absent,
        "user_reference": userReference
      };

  set setUserReference(DocumentReference<Map<String, dynamic>> newReference) {
    userReference = newReference;
  }

  set setAbsent(bool newAbsent) {
    absent = newAbsent;
  }
}
