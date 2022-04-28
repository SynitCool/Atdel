// firebase
import 'package:atdel/src/model/selected_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';
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
  Future joinRoomWithCode(String code) async {
    // get reference with code
    final status = await _roomCodesService.getRoomByCode(code);

    if (status == "code_not_valid") return status;

    final Room room = status;

    // check if room is private
    return await joinRoomPrivateRoom(room);
  }

  // join room private room
  Future joinRoomPrivateRoom(Room room) async {
    // get selected users by email
    final user = await _selectedUsersServices.getSelectedUsersByEmail(
        room, authUser!.email!);

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

    return "success";
  }

  // leave room private room
  Future leaveRoomPrivateRoom(Room room) async {
    // get selected users by email
    final user = await _selectedUsersServices.getSelectedUsersByEmail(
        room, authUser!.email!);

    if (user == null) return "user_not_available";

    // remove the user room references
    await _userService.removeRoomReference(authUser!.uid, room);

    // remove room users
    await _userRoomService.removeUserRoom(
        room, UserRoom.fromFirebaseAuth(authUser!));

    // delete user photo metric by current user
    await _userPhotoMetricService.deleteUserPhotoMetricCurrentUser(room);

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
    // if room private
    await leaveRoomPrivateRoom(room);
  }

  // kick room
  Future kickUserFromRoomPrivateRoom(Room room, UserRoom userRoom) async {
    // get selected users by email
    final user = await _selectedUsersServices.getSelectedUsersByEmail(
        room, userRoom.email);

    if (user == null) return "user_not_available";

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

    // delete user photo metric by current user
    await _userPhotoMetricService.deleteUserPhotoMetricCurrentUser(room);

    // update selected users
    SelectedUsers oldSelectedUser = SelectedUsers.copy(user);

    user.setJoined = false;

    _selectedUsersServices.updateSelectedUser(room, oldSelectedUser, user);
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

  // change host room
  Future changeHostRoom(Room room, UserRoom newHost) async {
    // get new host user
    final newHostUser = await _userService.getUserInfo(newHost.uid);
    final oldHost =
        await _userRoomService.getUserFromUsersRoomByUid(room, authUser!.uid);

    // selected users new host
    final newHostSelectedUsers = await _selectedUsersServices
        .getSelectedUsersByEmail(room, newHost.email);

    // change room info
    final Room oldRoom = Room.copy(room);

    final Room newRoom = Room(
        hostEmail: newHostUser.email,
        hostPhotoUrl: newHostUser.photoUrl,
        hostName: newHostUser.displayName,
        hostUid: newHostUser.uid,
        memberCounts: room.memberCounts,
        roomDesc: room.roomDesc,
        roomName: room.roomName,
        id: room.id,
        roomCode: room.roomCode,
        attendanceWithMl: room.attendanceWithMl);

    await updateRoomInfo(oldRoom, newRoom);

    // update new host room user room
    final newUserRoom = UserRoom.copy(newHost);

    newUserRoom.setPhotoUrl = newHostUser.photoUrl;
    newUserRoom.setAlias = newHostUser.displayName;

    await _userRoomService.updateUserRoom(room, newHost, newUserRoom);

    // remove selected user new host
    await _selectedUsersServices.removeSelectedUsers(
        room, newHostSelectedUsers!);

    // remove old host
    await _userRoomService.removeUserRoom(room, oldHost);
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
