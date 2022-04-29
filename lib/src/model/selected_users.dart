// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedUsers {
  final String email;

  String alias;
  bool joined;
  String? photoUrl;
  String? uid;

  SelectedUsers(
      {required this.alias,
      required this.email,
      required this.joined,
      required this.photoUrl,
      required this.uid});

  factory SelectedUsers.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return SelectedUsers(
        alias: data!["alias"],
        email: data["email"],
        joined: data["joined"],
        photoUrl: data["photo_url"],
        uid: data["uid"]);
  }

  factory SelectedUsers.copy(SelectedUsers selectedUsers) => SelectedUsers(
      alias: selectedUsers.alias,
      email: selectedUsers.email,
      joined: selectedUsers.joined,
      photoUrl: selectedUsers.photoUrl,
      uid: selectedUsers.uid);

  factory SelectedUsers.fromMap(Map<String, dynamic> map) => SelectedUsers(
      alias: map["alias"],
      email: map["email"],
      joined: map["joined"],
      photoUrl: map["photo_url"],
      uid: map["uid"]);

  Map<String, dynamic> toMap() => {
        "alias": alias,
        "email": email,
        "joined": joined,
        "photo_url": photoUrl,
        "uid": uid
      };

  set setJoined(bool newJoined) {
    joined = newJoined;
  }

  set setPhotoUrl(String? newPhotoUrl) {
    photoUrl = newPhotoUrl;
  }

  set setAlias(String newAlias) {
    alias = newAlias;
  }

  set setUid(String newUid) {
    uid = newUid;
  }
}