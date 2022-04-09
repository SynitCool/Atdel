// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttendance {
  final String displayName;
  final String email;
  final String photoUrl;
  final String uid;

  String alias;
  dynamic userReference;
  bool absent;

  UserAttendance(
      {required this.alias,
      required this.displayName,
      required this.email,
      required this.photoUrl,
      required this.uid,
      required this.userReference,
      required this.absent});

  factory UserAttendance.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>?> doc) {
    final data = doc.data();

    return UserAttendance(
        displayName: data!["display_name"],
        email: data["email"],
        alias: data["alias"],
        photoUrl: data["photo_url"],
        uid: data["uid"],
        userReference: data["user_reference"],
        absent: data["absent"]);
  }

  factory UserAttendance.fromMap(Map<String, dynamic> map) => UserAttendance(
      alias: map["alias"],
      displayName: map["display_name"],
      email: map["email"],
      photoUrl: map["photo_url"],
      uid: map["uid"],
      userReference: map["user_reference"],
      absent: map["absent"]);

  Map<String, dynamic> toMap() => {
        "absent": absent,
        "alias": alias,
        "display_name": displayName,
        "email": email,
        "photo_url": photoUrl,
        "uid": uid,
        "user_reference": userReference
      };

  // set absent
  set setAbsent(bool newAbsent) {
    absent = newAbsent;
  }
}
