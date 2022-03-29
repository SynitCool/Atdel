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

  // make attendance list feature to rooms document
  Future createFeature() async {
    final String collectionPath = "users/$userUid/rooms";
    final Map<String, dynamic> feature = {"attendance_list": []};

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    final DocumentReference<Map<String, dynamic>> docCollection =
        collection.doc(roomId);

    final DocumentSnapshot<Map<String, dynamic>> getDocCollection =
        await docCollection.get();

    final Map<String, dynamic>? docCollectionData = getDocCollection.data();

    final bool checkDocCollectionData =
        docCollectionData!.containsKey("attendance_list");

    if (!checkDocCollectionData) await docCollection.update(feature);
  }

  // adding attendance to document
  Future addAttendance(DateTime startDate, DateTime endDate) async {
    final String collectionPath = "users/$userUid/rooms";
    final Timestamp startDateTimestamp = Timestamp.fromDate(startDate);
    final Timestamp endDateTimestamp = Timestamp.fromDate(endDate);

    Map<String, dynamic> feature = {
      "date_end": endDateTimestamp,
      "date_start": startDateTimestamp
    };

    List<Map<String, dynamic>> usersFeature = [];

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    final DocumentReference<Map<String, dynamic>> docCollection =
        collection.doc(roomId);

    final DocumentSnapshot<Map<String, dynamic>> getDocCollection =
        await docCollection.get();

    final Map<String, dynamic>? docCollectionData = getDocCollection.data();

    final List<dynamic> infoUsers = docCollectionData!["info_users"];

    for (int i = 0; i < infoUsers.length; i++) {
      final Map<String, dynamic> currentUser = infoUsers[i];

      final String typeUser = currentUser["type"];

      final Map<String, dynamic> currentUserFeature = {
        "user_name": currentUser["user_name"],
        "user_email": currentUser["user_email"],
        "user_image_url": currentUser["user_image_url"],
        "absent": true
      };

      if (typeUser != "Host") usersFeature.add(currentUserFeature);
    }

    feature["users"] = usersFeature;

    List<dynamic> currentAttendanceList = docCollectionData["attendance_list"];

    currentAttendanceList.add(feature);

    final Map<String, dynamic> currentFeature = {
      "attendance_list": currentAttendanceList
    };

    await docCollection.update(currentFeature);
  }
}
