// firebase
import 'package:atdel/src/model/selected_users.dart';
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
import 'package:atdel/src/services/selected_users_services.dart';
import 'package:atdel/src/services/attendance_list_services.dart';

// other
import 'package:random_string_generator/random_string_generator.dart';

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

  final RoomCodesService _roomCodesService = RoomCodesService();
  final UserService _userService = UserService();
  final SelectedUsersServices _selectedUsersServices = SelectedUsersServices();
  final UserRoomService _userRoomService = UserRoomService();
  final UserPhotoMetricService _userPhotoMetricService =
      UserPhotoMetricService();
  final AttendanceListService _attendanceListService = AttendanceListService();

  final String rootRoomsCollection = "rooms";
  final String rootUsersCollection = "users";
  final String rootCodesCollection = "codes";

  final String roomCodesDoc = "room_codes";

  // get user info from database
  Future<Room> getRoomInfo(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(room.id);

    // get room info
    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return Room.fromFirestore(getDoc);
  }

  // set room and add to database
  Future setAddRoomToDatabase(Map<String, dynamic> info) async {
    // room collections
    final CollectionReference<Map<String, dynamic>> roomCollection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> roomDoc =
        roomCollection.doc();

    // set room
    Room room = Room.fromFirebaseAuth(authUser!);

    room.setRoomDesc = "<h1>Welcome</h1>";
    room.setRoomName = info["room_name"];
    room.setId = roomDoc.id;
    room.setRoomCode = makeRandomCode();
    room.setPrivateRoom = info["private_room"];
    room.setAttendanceWithMl = info["attendance_with_ml"];

    // add room to database
    await roomDoc.set(room.toMap());

    return room;
  }

  // add room to database
  Future addRoomToDatabase(
      Map<String, dynamic> roomInfo, String hostAlias) async {
    // settings room object and add to room Doc
    final Room room = await setAddRoomToDatabase(roomInfo);

    // settings room users
    await _userRoomService.setHostUserRoom(room, hostAlias);

    // update user room reference
    await _userService.addRoomReference(room);

    // add to room codes
    await _roomCodesService.addRoomCodes({
      "room_code": room.roomCode,
      "room_reference": _db.collection(rootRoomsCollection).doc(room.id)
    });
  }

  // join room with code
  Future joinRoomWithCode(String code, String userAlias) async {
    // get reference with code
    final status = await _roomCodesService.getRoomByCode(code);

    if (status == "code_not_valid") return status;

    final room = status;

    // check if room is private
    if (room.privateRoom) {
      await joinRoomPrivateRoom(room);
    }
    if (room.privateRoom) return;

    // update the user references
    _userService.addRoomReference(room);

    // update user room
    await _userRoomService.addUserRoomPublicRoom(room, userAlias);

    // update room info
    updateMembersCount(room, true);
  }

  // join room private room
  Future joinRoomPrivateRoom(Room room) async {
    // get selected users by email
    final user = await _selectedUsersServices.getSelectedUsersByEmail(
        room, model.User.fromFirebaseAuth(authUser!));

    if (user == null) return "user_not_include";

    // update the user room references
    await _userService.addRoomReference(room);

    // add user room
    await _userRoomService.addUserRoomPrivateRoom(room, user);

    // update room info
    updateMembersCount(room, true);

    // update selected users
    SelectedUsers oldSelectedUser = SelectedUsers.copy(user);

    user.setJoined = true;

    _selectedUsersServices.updateSelectedUser(room, oldSelectedUser, user);
  }

  // leave room private room
  Future leaveRoomPrivateRoom(
      Room room, DocumentReference<Map<String, dynamic>> usersDoc) async {
    // get selected users by email
    final user = await _selectedUsersServices.getSelectedUsersByEmail(
        room, model.User.fromFirebaseAuth(authUser!));

    // remove the user room references
    _userService.removeRoomReference(
        model.User.fromFirestore(await usersDoc.get()).uid, room);

    // update room users
    final UserRoom userRoom = UserRoom.fromFirebaseAuth(authUser!);
    userRoom.setUserReference = usersDoc;
    userRoom.setAlias = user!.alias;

    _userRoomService.removeUserRoom(room, userRoom);

    // delete user photo metric by current user
    _userPhotoMetricService.deleteUserPhotoMetricCurrentUser(room);

    // update selected users
    SelectedUsers oldSelectedUser = SelectedUsers.copy(user);

    user.setJoined = false;

    _selectedUsersServices.updateSelectedUser(room, oldSelectedUser, user);
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

  // delete room doc
  Future deleteRoomDoc(Room room) async {
    // room doc
    final CollectionReference<Map<String, dynamic>> roomCollection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> roomDoc =
        roomCollection.doc(room.id);

    // delete room from database
    await roomDoc.delete();
  }

  // delete room
  Future deleteRoomFromDatabase(Room room) async {
    // delete room code
    await _roomCodesService.deleteRoomCode(room);

    // delete users room references
    await _userRoomService.deleteUserRoomRoomReference(room);

    // delete room from database
    await deleteRoomDoc(room);

    // delete all room users
    await _userRoomService.deleteUsersRooms(room);

    // delete all attendance list
    await _attendanceListService.deleteAttendancesList(room);

    // delete all selected users
    await _selectedUsersServices.deleteSelectedUsers(room);

    // delete room user photo metric
    _userPhotoMetricService.deleteRoomUserPhotoMetric(room);
  }

  // leave room
  Future leaveRoom(Room room) async {
    // room collection
    final roomCollection = _db.collection(rootRoomsCollection);
    final roomDoc = roomCollection.doc(room.id);

    // room users collection
    final roomUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/users");
    final roomUserDoc = roomUsersCollection.doc(authUser!.uid);

    // users collection
    final usersCollection = _db.collection(rootUsersCollection);
    final userDoc = usersCollection.doc(authUser!.uid);

    // if room private
    if (room.privateRoom) leaveRoomPrivateRoom(room, userDoc);
    if (room.privateRoom) return;

    // remove room reference
    final getUserDoc = await userDoc.get();
    final oldUser = model.User.fromMap(getUserDoc.data()!);

    final newUser = model.User.copy(oldUser);

    newUser.roomReferences.remove(roomDoc);

    final userMap = newUser.toMap();

    await userDoc.update(userMap);

    // delete user in room users
    await roomUserDoc.delete();

    // delete user photo metric by current user
    _userPhotoMetricService.deleteUserPhotoMetricCurrentUser(room);

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
