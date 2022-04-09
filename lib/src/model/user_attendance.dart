// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user_room.dart';

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

  factory UserAttendance.fromUserRoom(UserRoom user) => UserAttendance(
      alias: user.alias,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
      uid: user.uid,
      userReference: user.userReference,
      absent: true);

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
