// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String displayName;
  final String email;
  final bool isAnonymous;
  final String photoUrl;
  final String uid;
  final bool absent;
  List<dynamic> roomReferences;

  User(
      {required this.displayName,
      required this.email,
      required this.isAnonymous,
      required this.photoUrl,
      required this.uid,
      required this.roomReferences,
      required this.absent});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    return User(
        displayName: data!["display_name"],
        email: data["email"],
        isAnonymous: data["is_anonymous"],
        photoUrl: data["photo_url"],
        uid: data["uid"],
        roomReferences: data["room_references"],
        absent: true);
  }

  factory User.fromFirebaseAuth(auth.User authUser) {
    return User(
        displayName: authUser.displayName!,
        email: authUser.email!,
        isAnonymous: authUser.isAnonymous,
        photoUrl: authUser.photoURL!,
        uid: authUser.uid,
        roomReferences: [],
        absent: true);
  }

  factory User.fromMap(Map<String, dynamic> map) => User(
      displayName: map["display_name"],
      email: map["email"],
      isAnonymous: map["is_anonymous"],
      photoUrl: map["photo_url"],
      uid: map["uid"],
      roomReferences: map["room_references"] ?? [],
      absent: map["absent"] ?? true);

  Map<String, dynamic> toMapUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid,
        "room_references": roomReferences
      };

  Map<String, dynamic> toMapRoomUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid
      };

  Map<String, dynamic> toMapAttendanceUsers() => {
        "display_name": displayName,
        "email": email,
        "is_anonymous": isAnonymous,
        "photo_url": photoUrl,
        "uid": uid,
        "absent": absent
      };
}
