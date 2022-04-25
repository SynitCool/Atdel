// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedUsers {
  final String alias;
  final String email;

  bool joined;

  SelectedUsers(
      {required this.alias, required this.email, required this.joined});

  factory SelectedUsers.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return SelectedUsers(
        alias: data!["alias"], email: data["email"], joined: data["joined"]);
  }

  factory SelectedUsers.copy(SelectedUsers selectedUsers) => SelectedUsers(
      alias: selectedUsers.alias,
      email: selectedUsers.email,
      joined: selectedUsers.joined);

  factory SelectedUsers.fromMap(Map<String, dynamic> map) => SelectedUsers(
      alias: map["alias"], email: map["email"], joined: map["joined"]);

  Map<String, dynamic> toMap() =>
      {"alias": alias, "email": email, "joined": joined};

  set setJoined(bool newJoined) {
    joined = newJoined;
  }
}
