// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart' as model;

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // get user info from database
  Future<Room> getRoomInfo(String roomid) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection("new_rooms");

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(roomid);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return Room.fromFirestore(getDoc);
  }

  // add room to database
  Future addRoomToDatabase(String roomName) async {
    // current user
    final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

    // room collections
    final CollectionReference<Map<String, dynamic>> roomCollection =
        _db.collection("new_rooms");

    final DocumentReference<Map<String, dynamic>> roomDoc =
        roomCollection.doc();

    // users collections
    final CollectionReference<Map<String, dynamic>> usersCollection =
        _db.collection("new_users");

    final DocumentReference<Map<String, dynamic>> usersDoc =
        usersCollection.doc(authUser!.uid);

    // settings room object and add to room Doc
    Room room = Room.fromFirebaseAuth(authUser);

    room.setRoomDesc = "<h1>Welcome</h1>";
    room.setRoomName = roomName;
    room.setId = roomDoc.id;

    final Map<String, dynamic> roomMap = room.toMap();

    await roomDoc.set(roomMap);

    // update users rooms
    final DocumentSnapshot<Map<String, dynamic>> getDoc = await usersDoc.get();

    model.User user = model.User.fromFirestore(getDoc);

    user.roomReferences.add(roomDoc);

    Map<String, dynamic> usersInfo = user.toMap();

    await usersDoc.update(usersInfo);
  }
}
