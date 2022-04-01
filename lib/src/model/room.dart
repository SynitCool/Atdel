// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Room {
  final String hostEmail;
  final String hostPhotoUrl;
  final String hostName;
  final int memberCounts;
  String roomDesc;
  String roomName;
  String id;
  String roomCode;

  Room(
      {required this.hostEmail,
      required this.hostPhotoUrl,
      required this.hostName,
      required this.memberCounts,
      required this.roomDesc,
      required this.roomName,
      required this.id,
      required this.roomCode});

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    return Room(
        hostEmail: data!["host_email"],
        hostPhotoUrl: data["host_photo_url"],
        hostName: data["host_name"],
        memberCounts: data["member_counts"],
        roomDesc: data["room_desc"],
        roomName: data["room_name"],
        id: data["id"],
        roomCode: data["room_code"]);
  }

  factory Room.fromFirebaseAuth(auth.User authUser) => Room(
      hostEmail: authUser.email!,
      hostPhotoUrl: authUser.photoURL!,
      hostName: authUser.displayName!,
      memberCounts: 1,
      roomDesc: "",
      roomName: "",
      id: "",
      roomCode: "");

  factory Room.fromMap(Map<String, dynamic> map) => Room(
      hostEmail: map["host_email"],
      hostPhotoUrl: map["host_photo_url"],
      hostName: map["host_name"],
      memberCounts: map["member_counts"],
      roomDesc: map["room_desc"],
      roomName: map["room_name"],
      id: map["id"],
      roomCode: map["room_code"]);

  Map<String, dynamic> toMap() => {
        "host_email": hostEmail,
        "host_photo_url": hostPhotoUrl,
        "host_name": hostName,
        "member_counts": memberCounts,
        "room_desc": roomDesc,
        "room_name": roomName,
        "id": id,
        "room_code": roomCode
      };

  set setRoomDesc(String newRoomDesc) {
    roomDesc = newRoomDesc;
  }

  set setRoomName(String newRoomName) {
    roomName = newRoomName;
  }

  set setId(String newId) {
    id = newId;
  }

  set setRoomCode(String newCode) {
    roomCode = newCode;
  }
}
