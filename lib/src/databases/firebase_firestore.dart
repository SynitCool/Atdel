import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Room {
  String id;
  final Map<String, dynamic> info;
  final List<Map<String, dynamic>> users;

  Room({this.id = "", required this.info, required this.users});

  Map<String, dynamic> toJson() {
    Map<String, Map<String, dynamic>> usersToMap = {};
    Map<String, dynamic> output = {};

    for (int i = 0; i < users.length; i++) {
      String name = '';
      Map<String, dynamic> sign = {};

      users[i].forEach((key, value) {
        if (key == "user_uid") {
          name = value;
        } else {
          sign[key] = value;
        }
      });

      usersToMap[name] = sign;
    }

    output["info"] = info;
    output["id"] = id;

    usersToMap.forEach((key, value) {
      output[key] = value;
    });

    debugPrint(output.toString());

    return output;
  }

  Future createRoom() async {
    final docRoom = FirebaseFirestore.instance.collection("rooms").doc();

    id = docRoom.id;

    final room = toJson();

    await docRoom.set(room);
  }

  static Room fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> users = [];
    Map<String, dynamic> info = json["info"];
    String id = json["id"];

    json.forEach((key, value) {
      if (key == "info" || key == "id") return;

      Map<String, dynamic> user = {};

      user["user_name"] = json[key]["user_name"];
      user["user_email"] = json[key]["user_email"];
      user["user_uid"] = json[key]["user_uid"];
      user["user_image_url"] = json[key]["user_image_url"];
      user["type"] = json[key]["type"];

      users.add(user);
    });

    final Room newRoom = Room(info: info, id: id, users: users);

    return newRoom;
  }
}

class User {
  final String uid;
  final Map<String, dynamic> info;
  final List<String> rooms;

  User({required this.uid, required this.info, required this.rooms});

  Map<String, dynamic> toJson() => {"id": uid, "info": info, "rooms": rooms};

  Future createAccount() async {
    final docRoom = FirebaseFirestore.instance.collection("users").doc(uid);

    final Map<String, dynamic> user = toJson();

    bool docExists = await checkAccountExists(uid);

    if (docExists) return;


    await docRoom.set(user);
  }

  // checking the account exist
  Future<bool> checkAccountExists(String docId) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection("users");

      final doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}
