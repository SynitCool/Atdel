import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class Room {
  String roomId;

  Room({this.roomId = ""});

  Map<String, dynamic> toJson(String id, Map<String, dynamic> infoRoom,
          List<Map<String, dynamic>> infoUsers) =>
      {"id": id, "info_room": infoRoom, "info_users": infoUsers};

  Future createRoom(Map<String, dynamic> infoRoom,
      List<Map<String, dynamic>> infoUsers) async {
    // firebase user
    final fire_auth.User? firebaseUser =
        fire_auth.FirebaseAuth.instance.currentUser;
    final String userUid = firebaseUser!.uid;

    final CollectionReference<Map<String, dynamic>> userRooms =
        FirebaseFirestore.instance.collection("users/$userUid/rooms");

    final DocumentReference<Map<String, dynamic>> docUserRooms =
        userRooms.doc();

    final String id = docUserRooms.id;

    final room = toJson(id, infoRoom, infoUsers);

    await docUserRooms.set(room);
  }

  Future deleteRoom() async {
    // check if room id is empty
    if (roomId.isEmpty) return;

    // firebase user
    final fire_auth.User? firebaseUser =
        fire_auth.FirebaseAuth.instance.currentUser;

    final String userUid = firebaseUser!.uid;

    // firestore
    final String roomCollectionPath = "users/$userUid/rooms";

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(roomCollectionPath);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(roomId);

    // delete room
    await doc.delete();
  }

  Future updateRoomDesc(String roomDesc) async {
    // check if room id empty
    if (roomId.isEmpty) return;

    // firebase user
    final fire_auth.User? firebaseUser =
        fire_auth.FirebaseAuth.instance.currentUser;
    final String firebaseUserUid = firebaseUser!.uid;

    // collection room
    final String collectionPath = "users/$firebaseUserUid/rooms";

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    // doc room
    final DocumentReference<Map<String, dynamic>> docRoom =
        collection.doc(roomId);

    final DocumentSnapshot<Map<String, dynamic>> getDocRoom =
        await docRoom.get();

    final Map<String, dynamic>? docRoomData = getDocRoom.data();

    final Map<String, dynamic> roomInfo = docRoomData!["info_room"];

    // updated data room info
    Map<String, dynamic> updatedRoomDesc = {};

    roomInfo["room_desc"] = roomDesc;

    updatedRoomDesc["info_room"] = roomInfo;

    // update database

    await docRoom.update(updatedRoomDesc);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamRoomDoc() {
    // check if room id empty
    if (roomId.isEmpty) return null;

    // firebase user
    final fire_auth.User? firebaseUser =
        fire_auth.FirebaseAuth.instance.currentUser;
    final String firebaseUserUid = firebaseUser!.uid;

    // collection room
    final String collectionPath = "users/$firebaseUserUid/rooms";

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    // doc room
    final DocumentReference<Map<String, dynamic>> docRoom =
        collection.doc(roomId);

    return docRoom.snapshots();
  }

  static Future<Map<String, dynamic>?> getRoomDocByReference(
      DocumentReference<Map<String, dynamic>> reference) async {
    // get reference
    final DocumentSnapshot<Map<String, dynamic>> getDocData =
        await reference.get();
    final Map<String, dynamic>? docData = getDocData.data();

    return docData;
  }
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

class AttendanceList {
  final String roomId;
  final String userUid;

  AttendanceList({required this.roomId, required this.userUid});

  // adding attendance to document
  Future addAttendance(DateTime startDate, DateTime endDate,
      {required String roomId, required String userUid}) async {
    // set attendance list info
    final String collectionPath =
        "users/$userUid/rooms/$roomId/attendance_list";
    final Timestamp startDateTimestamp = Timestamp.fromDate(startDate);
    final Timestamp endDateTimestamp = Timestamp.fromDate(endDate);

    Map<String, dynamic> feature = {
      "date_end": endDateTimestamp,
      "date_start": startDateTimestamp
    };

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    final DocumentReference<Map<String, dynamic>> docCollection =
        collection.doc();

    feature["id"] = docCollection.id;

    // get users in room
    final String collectionRoomPath = "users/$userUid/rooms";

    final DocumentReference<Map<String, dynamic>> docRoomInfo =
        FirebaseFirestore.instance.collection(collectionRoomPath).doc(roomId);

    final DocumentSnapshot<Map<String, dynamic>> getRoomInfo =
        await docRoomInfo.get();

    final Map<String, dynamic>? roomInfoData = getRoomInfo.data();

    final List<dynamic> infoUsers = roomInfoData!["info_users"];

    List<Map<String, dynamic>> users = [];
    for (Map<String, dynamic> user in infoUsers) {
      if (user["type"] == "Host") continue;

      user.addAll({"absent": true});

      users.add(user);
    }

    feature["users"] = users;

    await docCollection.set(feature);
  }
}
