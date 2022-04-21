// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart' as model;
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';
import 'package:atdel/src/services/room_codes_services.dart';
import 'package:atdel/src/services/user_services.dart';

// other
import 'package:random_string_generator/random_string_generator.dart';

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

  final RoomCodesService _roomCodesService = RoomCodesService();
  final UserService _userService = UserService();

  final String rootRoomsCollection = "rooms";
  final String rootUsersCollection = "users";
  final String rootCodesCollection = "codes";

  final String roomCodesDoc = "room_codes";

  // get user info from database
  Future<Room> getRoomInfo(Room room) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(room.id);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return Room.fromFirestore(getDoc);
  }

  // add room to database
  Future addRoomToDatabase(
      Map<String, dynamic> roomInfo, String hostAlias) async {
    // room collections
    final CollectionReference<Map<String, dynamic>> roomCollection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> roomDoc =
        roomCollection.doc();

    // users collections
    final CollectionReference<Map<String, dynamic>> usersCollection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> usersDoc =
        usersCollection.doc(authUser!.uid);

    // room users collections
    final String roomUsersPath = "$rootRoomsCollection/${roomDoc.id}/users";

    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection(roomUsersPath);

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser!.uid);

    // settings room object and add to room Doc
    Room room = Room.fromFirebaseAuth(authUser!);

    room.setRoomDesc = "<h1>Welcome</h1>";
    room.setRoomName = roomInfo["room_name"];
    room.setId = roomDoc.id;
    room.setRoomCode = makeRandomCode();
    room.setPrivateRoom = roomInfo["private_room"];
    room.setAttendanceWithMl = roomInfo["attendance_with_ml"];

    final Map<String, dynamic> roomMap = room.toMap();

    await roomDoc.set(roomMap);

    // settings room users
    UserRoom hostUser = UserRoom(
        alias: hostAlias,
        displayName: authUser!.displayName!,
        email: authUser!.email!,
        photoUrl: authUser!.photoURL!,
        uid: authUser!.uid,
        userReference: usersDoc);

    Map<String, dynamic> hostUserMap = hostUser.toMap();

    await roomUsersDoc.set(hostUserMap);

    // update user room reference
    final DocumentSnapshot<Map<String, dynamic>> getDoc = await usersDoc.get();

    model.User oldUser = model.User.fromFirestore(getDoc);
    model.User newUser = model.User.copy(oldUser);

    newUser.roomReferences.add(roomDoc);

    await _userService.updateUser(oldUser, newUser);

    // add to room codes
    await _roomCodesService
        .addRoomCodes({"room_code": room.roomCode, "room_reference": roomDoc});
  }

  // join room with code
  Future joinRoomWithCode(String code, String userAlias) async {
    // current user
    final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

    // room codes doc
    final CollectionReference<Map<String, dynamic>> roomCodesCollection =
        _db.collection(rootCodesCollection);

    final DocumentReference<Map<String, dynamic>> codesDoc =
        roomCodesCollection.doc(roomCodesDoc);

    // users doc
    final CollectionReference<Map<String, dynamic>> usersCollection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> usersDoc =
        usersCollection.doc(authUser!.uid);

    // get reference with code
    final DocumentSnapshot<Map<String, dynamic>> getRoomCodesDoc =
        await codesDoc.get();

    final Map<String, dynamic> roomCodesMap = getRoomCodesDoc.data()!;

    // check valid code
    if (!roomCodesMap.containsKey(code)) return;

    // room users doc and update room users
    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection("${roomCodesMap[code].path}/users");

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser.uid);

    // update the user references
    final DocumentSnapshot<Map<String, dynamic>> getUsersDoc =
        await usersDoc.get();

    final model.User userModel = model.User.fromFirestore(getUsersDoc);

    userModel.roomReferences.add(roomCodesMap[code]);
    userModel.setUserReference = usersDoc;

    Map<String, dynamic> userModelInfo = userModel.toMap();

    await usersDoc.update(userModelInfo);

    // update room users
    final UserRoom userRoom = UserRoom.fromFirebaseAuth(authUser);
    userRoom.setUserReference = usersDoc;
    userRoom.setAlias = userAlias;

    Map<String, dynamic> userRoomMap = userRoom.toMap();

    await roomUsersDoc.set(userRoomMap);

    // update room info
    final roomDoc = await roomCodesMap[code].get();
    final room = Room.fromFirestore(roomDoc);

    updateMembersCount(room, true);
  }

  // change room desc
  Future changeRoomDesc(String roomId, String newRoomDesc) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(roomId);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    Room room = Room.fromFirestore(getDoc);

    room.roomDesc = newRoomDesc;

    final Map<String, dynamic> map = room.toMap();

    await doc.update(map);
  }

  // delete room
  Future deleteRoomFromDatabase(Room room) async {
    // room doc
    final CollectionReference<Map<String, dynamic>> roomCollection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> roomDoc =
        roomCollection.doc(room.id);

    // room codes code
    final CollectionReference<Map<String, dynamic>> roomCodesCollection =
        _db.collection(rootCodesCollection);

    final DocumentReference<Map<String, dynamic>> roomCodesDoc =
        roomCodesCollection.doc("room_codes");

    // delete room code
    final DocumentSnapshot<Map<String, dynamic>> getRoomCodes =
        await roomCodesDoc.get();

    final Map<String, dynamic>? roomCodesMap = getRoomCodes.data();

    roomCodesMap!.remove(room.roomCode);

    await roomCodesDoc.set(roomCodesMap);

    // delete users room references
    final userRoomService = UserRoomService();
    final Stream<List<UserRoom>> streamRoomUsers =
        userRoomService.streamUsersRoom(room);

    streamRoomUsers.forEach((elements) async {
      for (final element in elements) {
        final DocumentSnapshot<Map<String, dynamic>> getUserReference =
            await element.userReference.get();

        final model.User user = model.User.fromMap(getUserReference.data()!);

        user.roomReferences.remove(roomDoc);

        final Map<String, dynamic> map = user.toMap();

        await element.userReference.update(map);
      }
    });

    // delete room from database
    await roomDoc.delete();

    // delete all room users
    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");

    roomUsersCollection.get().then((snapshot) {
      for (final snap in snapshot.docs) {
        snap.reference.delete();
      }
    });

    // delete all attendance list
    final CollectionReference<Map<String, dynamic>> attendanceListCollection =
        _db.collection("$rootRoomsCollection/${room.id}/attendance_list");

    attendanceListCollection.get().then((snapshot) {
      for (final snap in snapshot.docs) {
        final referencePath = snap.reference.path;

        final collectionUsersReference = _db.collection("$referencePath/users");

        collectionUsersReference.get().then((usersSnapshot) {
          for (final userSnap in usersSnapshot.docs) {
            userSnap.reference.delete();
          }
        });

        snap.reference.delete();
      }
    });

    // delete room user photo metric
    final UserPhotoMetricService userPhotoMetricService =
        UserPhotoMetricService();

    userPhotoMetricService.deleteRoomUserPhotoMetric(room);
  }

  // leave room
  Future leaveRoom(Room room) async {
    // auth user
    final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

    // room collection
    final roomCollection = _db.collection(rootRoomsCollection);
    final roomDoc = roomCollection.doc(room.id);

    // room users collection
    final roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");
    final roomUserDoc = roomUsersCollection.doc(authUser!.uid);

    // users collection
    final usersCollection = _db.collection(rootUsersCollection);
    final userDoc = usersCollection.doc(authUser.uid);

    // remove room reference
    final getUserDoc = await userDoc.get();
    final user = model.User.fromMap(getUserDoc.data()!);

    user.roomReferences.remove(roomDoc);

    final userMap = user.toMap();

    await userDoc.update(userMap);

    // delete user in room users
    await roomUserDoc.delete();

    // delete user photo metric by current user
    final UserPhotoMetricService userPhotoMetricService =
        UserPhotoMetricService();

    userPhotoMetricService.deleteUserPhotoMetricCurrentUser(room);

    // decrease member counts
    updateMembersCount(room, false);
  }

  // update room info
  Future updateRoomInfo(Room oldRoom, Room newRoom) async {
    // room collection
    final roomCollection = _db.collection(rootRoomsCollection);
    final roomDoc = roomCollection.doc(oldRoom.id);

    // update room
    Map<String, dynamic> newRoomMap = newRoom.toMap();

    await roomDoc.update(newRoomMap);
  }

  // update member count
  Future updateMembersCount(Room room, bool add) async {
    final roomInfo = await getRoomInfo(room);

    final oldRoom = Room.copy(roomInfo);

    if (add) roomInfo.memberCounts++;
    if (!add) roomInfo.memberCounts--;

    // update
    await updateRoomInfo(oldRoom, roomInfo);
  }

  // stream global rooms
  Stream<List<Room>> streamGlobalRooms() {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final Stream<List<Room>> snapshot = collection.snapshots().map(
        (snap) => snap.docs.map((data) => Room.fromMap(data.data())).toList());

    return snapshot;
  }

  // stream local rooms
  Stream<Room> streamReferenceRoom(
      DocumentReference<Map<String, dynamic>> reference) {
    final Stream<Room> snapshot =
        reference.snapshots().map((data) => Room.fromMap(data.data()!));

    return snapshot;
  }

  // stream get room info
  Stream<Room> streamGetRoomInfo(String roomId) {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(roomId);

    final Stream<Room> stream =
        doc.snapshots().map((data) => Room.fromMap(data.data()!));

    return stream;
  }

  // make random code
  static String makeRandomCode() {
    // generator
    final RandomStringGenerator generator =
        RandomStringGenerator(fixedLength: 6);

    generator.hasSymbols = false;
    generator.hasDigits = false;

    return generator.generate();
  }
}
