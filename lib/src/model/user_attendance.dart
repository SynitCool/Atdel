// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttendance {
  final String displayName;
  final String email;
  final bool isAnonymous;
  final String photoUrl;
  final String uid;
  final DocumentReference<Map<String, dynamic>?> userReference;
  final bool absent;

  UserAttendance(
      {required this.displayName,
      required this.email,
      required this.isAnonymous,
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
        isAnonymous: data["is_anonymous"],
        photoUrl: data["photo_url"],
        uid: data["uid"],
        userReference: data["user_reference"],
        absent: data["absent"]);
  }
}
