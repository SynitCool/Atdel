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
}
