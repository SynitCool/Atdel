// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user_room.dart';
import 'package:atdel/src/model/room.dart';

class UserRoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // get members room
  Future<List<UserRoom>> getMembersRoom(Room room) async {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final getCollection = await collection.get();

    final usersRoom =
        getCollection.docs.map((data) => UserRoom.fromMap(data.data()));

    return usersRoom.toList();
  }

  // get users room
  Future<List<UserRoom>> getUsersRoom(Room room) async {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final getCollection = await collection.get();

    final usersRoom =
        getCollection.docs.map((data) => UserRoom.fromMap(data.data()));

    return usersRoom.toList();
  }

  // stream user room
  Stream<List<UserRoom>> streamUsersRoom(Room room) {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final Stream<List<UserRoom>> stream = collection.snapshots().map((data) =>
        data.docs.map((doc) => UserRoom.fromMap(doc.data())).toList());

    return stream;
  }
}
