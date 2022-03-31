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

  Room(
      {required this.hostEmail,
      required this.hostPhotoUrl,
      required this.hostName,
      required this.memberCounts,
      required this.roomDesc,
      required this.roomName,
      required this.id});

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    return Room(
        hostEmail: data!["host_email"],
        hostPhotoUrl: data["host_photo_url"],
        hostName: data["host_name"],
        memberCounts: data["member_counts"],
        roomDesc: data["room_desc"],
        roomName: data["room_name"],
        id: data["id"]);
  }

  factory Room.fromFirebaseAuth(auth.User authUser) => Room(
      hostEmail: authUser.email!,
      hostPhotoUrl: authUser.photoURL!,
      hostName: authUser.displayName!,
      memberCounts: 1,
      roomDesc: "",
      roomName: "",
      id: "");

  Map<String, dynamic> toMap() => {
        "host_email": hostEmail,
        "host_photo_url": hostPhotoUrl,
        "host_name": hostName,
        "member_counts": memberCounts,
        "room_desc": roomDesc,
        "room_name": roomName,
        "id": id
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
}
