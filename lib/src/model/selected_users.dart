// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedUsers {
  final String alias;
  final String email;

  SelectedUsers({required this.alias, required this.email});

  factory SelectedUsers.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return SelectedUsers(alias: data!["alias"], email: data["email"]);
  }

  factory SelectedUsers.fromMap(Map<String, dynamic> map) =>
      SelectedUsers(alias: map["alias"], email: map["email"]);

  Map<String, dynamic> toMap() => {"alias": alias, "email": email};

  
}
