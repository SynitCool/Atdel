// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedUsers {
  final String alias;
  final String email;

  bool joined;
  String? photoUrl;

  SelectedUsers(
      {required this.alias,
      required this.email,
      required this.joined,
      required this.photoUrl});

  factory SelectedUsers.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return SelectedUsers(
        alias: data!["alias"],
        email: data["email"],
        joined: data["joined"],
        photoUrl: data["photo_url"]);
  }

  factory SelectedUsers.copy(SelectedUsers selectedUsers) => SelectedUsers(
      alias: selectedUsers.alias,
      email: selectedUsers.email,
      joined: selectedUsers.joined,
      photoUrl: selectedUsers.photoUrl);

  factory SelectedUsers.fromMap(Map<String, dynamic> map) => SelectedUsers(
      alias: map["alias"],
      email: map["email"],
      joined: map["joined"],
      photoUrl: map["photo_url"]);

  Map<String, dynamic> toMap() =>
      {"alias": alias, "email": email, "joined": joined, "photo_url": photoUrl};

  set setJoined(bool newJoined) {
    joined = newJoined;
  }

  set setPhotoUrl(String? newPhotoUrl) {
    photoUrl = newPhotoUrl;
  }
}
