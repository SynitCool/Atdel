import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class Room {
  String id;
  final Map<String, dynamic> infoRoom;
  final List<Map<String, dynamic>> infoUsers;

  Room({this.id = "", required this.infoRoom, required this.infoUsers});

  Map<String, dynamic> toJson() =>
      {"id": id, "info_room": infoRoom, "info_users": infoUsers};

  Future createRoom(fire_auth.User currentUser) async {
    final String userUid = currentUser.uid;

    final CollectionReference<Map<String, dynamic>> userRooms =
        FirebaseFirestore.instance.collection("users/$userUid/rooms");

    final DocumentReference<Map<String, dynamic>> docUserRooms =
        userRooms.doc();

    id = docUserRooms.id;

    final room = toJson();

    await docUserRooms.set(room);
  }

  static Room fromJson(Map<String, dynamic> json) => Room(
      id: json["id"],
      infoRoom: json["info_room"],
      infoUsers: json["info_users"]);
}

class User {
  final String uid;
  final Map<String, dynamic> info;

  User({required this.uid, required this.info});

  // converts to json
  Map<String, dynamic> toJson() => {"id": uid, "info": info};

  // converts from json to user object
  static User fromJson(Map<String, dynamic>? json) =>
      User(uid: json!["id"], info: json["info"]);

  // check account
  Future<User> checkAccount() async {
    final CollectionReference<Map<String, dynamic>> userCollection =
        FirebaseFirestore.instance.collection("users");

    // check the uid is exist
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await userCollection.doc(uid).get();
    final bool docExists = doc.exists;

    if (docExists) {
      final User user = fromJson(doc.data());

      return user;
    } else {
      final Map<String, dynamic> userJson = toJson();

      await userCollection.doc(uid).set(userJson);

      return this;
    }
  }

  // check account stream
  static Stream<User> checkAccountStream(String uid) async* {
    final CollectionReference<Map<String, dynamic>> userCollection =
        FirebaseFirestore.instance.collection("users");

    bool docExists = false;

    while (!docExists) {
      // check the uid is exist
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await userCollection.doc(uid).get();
      docExists = doc.exists;

      if (docExists) {
        final User user = fromJson(doc.data());

        yield user;
      }
    }
  }
}
