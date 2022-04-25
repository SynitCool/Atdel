// firebase
import 'package:atdel/src/model/selected_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// services
import 'package:atdel/src/services/user_services.dart';
import 'package:atdel/src/services/room_services.dart';

// model
import 'package:atdel/src/model/user_room.dart';
import 'package:atdel/src/model/user.dart';
import 'package:atdel/src/model/room.dart';

class UserRoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

  final String rootRoomsCollection = "rooms";
  final String rootUsersCollection = "users";

  // delete current user room
  Future deleteCurrentUserRoom(Room room) async {
    // room users collection
    final roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");
    final roomUserDoc = roomUsersCollection.doc(authUser!.uid);

    // delete current user room in room
    await roomUserDoc.delete();
  }

  // delete all users room
  Future deleteUsersRooms(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");

    // delete all users rooms
    roomUsersCollection.get().then((snapshot) {
      for (final snap in snapshot.docs) {
        snap.reference.delete();
      }
    });
  }

  // delete user rooms room reference
  Future deleteUserRoomRoomReference(Room room) async {
    // stream
    final Stream<List<UserRoom>> streamRoomUsers = streamUsersRoom(room);

    streamRoomUsers.forEach((elements) async {
      for (final element in elements) {
        final DocumentSnapshot<Map<String, dynamic>> getUserReference =
            await element.userReference.get();

        final User user = User.fromMap(getUserReference.data()!);

        user.roomReferences
            .remove(_db.collection(rootRoomsCollection).doc(room.id));

        final Map<String, dynamic> map = user.toMap();

        await element.userReference.update(map);
      }
    });
  }

  // set host user as user room
  Future setHostUserRoom(Room room, String hostAlias) async {
    // room users collections
    final String roomUsersPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection(roomUsersPath);

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser!.uid);

    // settings room users
    UserRoom hostUser = UserRoom(
        alias: hostAlias,
        displayName: authUser!.displayName!,
        email: authUser!.email!,
        photoUrl: authUser!.photoURL!,
        uid: authUser!.uid,
        userReference: _db.collection(rootUsersCollection).doc(authUser!.uid));

    Map<String, dynamic> hostUserMap = hostUser.toMap();

    await roomUsersDoc.set(hostUserMap);
  }

  // add user room private room
  Future addUserRoomPrivateRoom(Room room, SelectedUsers user) async {
    // collection
    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser!.uid);

    // set user room
    final UserRoom userRoom = UserRoom.fromFirebaseAuth(authUser!);
    userRoom.setUserReference =
        _db.collection(rootUsersCollection).doc(authUser!.uid);
    userRoom.setAlias = user.alias;

    // set to user room
    await roomUsersDoc.set(userRoom.toMap());

    return userRoom;
  }

  // add user room public room
  Future addUserRoomPublicRoom(Room room, String userAlias) async {
    // collection
    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser!.uid);

    // set user room
    final UserRoom userRoom = UserRoom.fromFirebaseAuth(authUser!);
    userRoom.setUserReference =
        _db.collection(rootUsersCollection).doc(authUser!.uid);
    userRoom.setAlias = userAlias;

    // set to user room
    await roomUsersDoc.set(userRoom.toMap());

    return userRoom;
  }

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

  // get user from users room
  Future<UserRoom> getUserFromUsersRoom(Room room, User user) async {
    // collection
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final doc = collection.doc(user.uid);

    // get user
    final getDoc = await doc.get();

    return UserRoom.fromFirestore(getDoc);
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
