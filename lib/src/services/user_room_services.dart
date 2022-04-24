// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// services
import 'package:atdel/src/services/user_services.dart';
import 'package:atdel/src/services/room_services.dart';

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

  // remove user room from room
  Future removeUserRoom(Room room, UserRoom userRoom) async {
    // services
    final userService = UserService();
    final roomService = RoomService();

    // collection
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final DocumentReference<Map<String, dynamic>> doc =
        collection.doc(userRoom.uid);

    // remove user room
    await doc.delete();

    // remove room reference
    await userService.removeRoomReference(userRoom.uid, room);

    // decrease member counts
    await roomService.updateMembersCount(room, false);
  }

  // get users room no host
  Future<List<UserRoom>> getUsersRoomNoHost(Room room) async {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final getCollection = await collection.get();

    final usersRoom = getCollection.docs.map((data) {
      if (room.hostUid == data.data()["uid"]) return null;

      return UserRoom.fromMap(data.data());
    });

    final List<dynamic> usersRoomNoHost = usersRoom.toList();

    usersRoomNoHost.remove(null);

    return List<UserRoom>.from(usersRoomNoHost);
  }

  // update user room
  Future updateUserRoom(
      Room room, UserRoom oldUserRoom, UserRoom newUserRoom) async {
    // collection
    final collectionPath = "$rootRoomsCollection/${room.id}/users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(oldUserRoom.uid);

    // update user room
    await doc.update(newUserRoom.toMap());
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
