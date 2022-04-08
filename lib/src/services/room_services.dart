// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart' as model;
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';

// other
import 'package:random_string_generator/random_string_generator.dart';

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";
  final String rootUsersCollection = "users";
  final String rootCodesCollection = "codes";

  final String roomCodesDoc = "room_codes";

  // get user info from database
  Future<Room> getRoomInfo(String roomid) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(roomid);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return Room.fromFirestore(getDoc);
  }

  // add room to database
  Future addRoomToDatabase(String roomName, String hostAlias) async {
    // current user
    final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

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

    // codes collection
    final CollectionReference<Map<String, dynamic>> codesCollection =
        _db.collection(rootCodesCollection);

    final DocumentReference<Map<String, dynamic>> codesDoc =
        codesCollection.doc(roomCodesDoc);

    // room users collections
    final String roomUsersPath = "$rootRoomsCollection/${roomDoc.id}/users";

    final CollectionReference<Map<String, dynamic>> roomUsersCollection =
        _db.collection(roomUsersPath);

    final DocumentReference<Map<String, dynamic>> roomUsersDoc =
        roomUsersCollection.doc(authUser.uid);

    // settings room object and add to room Doc
    Room room = Room.fromFirebaseAuth(authUser);

    room.setRoomDesc = "<h1>Welcome</h1>";
    room.setRoomName = roomName;
    room.setId = roomDoc.id;
    room.setRoomCode = makeRandomCode();

    final Map<String, dynamic> roomMap = room.toMap();

    await roomDoc.set(roomMap);

    // settings room users
    UserRoom hostUser = UserRoom(
        alias: hostAlias,
        displayName: authUser.displayName!,
        email: authUser.email!,
        photoUrl: authUser.photoURL!,
        uid: authUser.uid,
        userReference: usersDoc);

    Map<String, dynamic> hostUserMap = hostUser.toMap();

    await roomUsersDoc.set(hostUserMap);

    // model.User modelUser = model.User.fromFirebaseAuth(authUser);

    // modelUser.setUserReference = usersDoc;

    // Map<String, dynamic> modelUserMap = modelUser.toMapRoomUsers();

    // await roomUsersDoc.set(modelUserMap);

    // update users rooms
    final DocumentSnapshot<Map<String, dynamic>> getDoc = await usersDoc.get();

    model.User user = model.User.fromFirestore(getDoc);

    user.roomReferences.add(roomDoc);

    Map<String, dynamic> usersInfo = user.toMapUsers();

    await usersDoc.update(usersInfo);

    // add to room codes
    final DocumentSnapshot<Map<String, dynamic>> getCodes =
        await codesDoc.get();

    final Map<String, dynamic>? codesMap = getCodes.data();

    codesMap!.addAll({room.roomCode: roomDoc});

    await codesDoc.update(codesMap);
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

    Map<String, dynamic> userModelInfo = userModel.toMapUsers();

    await usersDoc.update(userModelInfo);

    // update room users
    // Map<String, dynamic> userInfo = userModel.toMapRoomUsers();

    final UserRoom userRoom = UserRoom.fromFirebaseAuth(authUser);
    userRoom.setUserReference = usersDoc;
    userRoom.setAlias = userAlias;

    Map<String, dynamic> userRoomMap = userRoom.toMap();

    await roomUsersDoc.set(userRoomMap);
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

  // add attendance
  Future addAttendanceToDatabase(
      Room room, DateTime dateStart, DateTime dateEnd) async {
    // attendace list collection
    final String attendanceListCollectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list";
    final CollectionReference<Map<String, dynamic>> attendanceListCollection =
        _db.collection(attendanceListCollectionPath);

    // attendance doc
    final DocumentReference<Map<String, dynamic>> attendanceListDoc =
        attendanceListCollection.doc();

    // set to database
    Attendance attendance = Attendance(
        dateStart: dateStart, dateEnd: dateEnd, id: attendanceListDoc.id);

    final Map<String, dynamic> map = attendance.toMap();

    await attendanceListDoc.set(map);

    // attendance users collection
    final String attendanceUsersCollectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendanceListDoc.id}/users";
    final CollectionReference<Map<String, dynamic>> attendanceUsersCollection =
        _db.collection(attendanceUsersCollectionPath);

    // room users docs
    final roomUsers = streamUsersRoom(room);

    roomUsers.forEach((elements) async {
      for (final element in elements) {
        if (room.hostUid == element.uid) continue;

        final elementDoc = attendanceUsersCollection.doc(element.uid);

        final map = element.toMapAttendanceUsers();

        await elementDoc.set(map);
      }
    });
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

        final Map<String, dynamic> map = user.toMapUsers();

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
  }

  // update absent user
  Future updateAbsentUser(Room room, Attendance attendance) async {
    // auth user
    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

    final model.User currentUser = model.User.fromFirebaseAuth(firebaseUser!);

    // stream attendance users
    final Stream<QuerySnapshot<Map<String, dynamic>>>
        streamAttendanceUsersReference =
        streamUsersAttendanceReference(room, attendance);

    streamAttendanceUsersReference.forEach((snapshot) async {
      for (final doc in snapshot.docs) {
        final model.User user = model.User.fromMap(doc.data());

        if (user.uid != currentUser.uid) return;

        user.setAbsent = false;

        Map<String, dynamic> userMap = user.toMapAttendanceUsers();

        final DocumentReference<Map<String, dynamic>> userDoc = doc.reference;

        await userDoc.update(userMap);
      }
    });
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

    final userMap = user.toMapUsers();

    await userDoc.update(userMap);

    // delete user in room users
    await roomUserDoc.delete();
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

  // stream users room
  Stream<List<model.User>> streamUsersRoom(Room room) {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    final Stream<List<model.User>> stream = collection.snapshots().map((data) =>
        data.docs.map((doc) => model.User.fromMap(doc.data())).toList());

    return stream;
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

  // stream attendance list
  Stream<List<Attendance>> streamAttendanceList(Room room) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list";
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final Stream<List<Attendance>> stream = collection
        .orderBy("date_start", descending: true)
        .snapshots()
        .map((data) =>
            data.docs.map((data) => Attendance.fromMap(data.data())).toList());

    return stream;
  }

  // stream users attendance
  Stream<List<model.User>> streamUsersAttendance(
      Room room, Attendance attendance) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => model.User.fromMap(data.data())).toList());

    return stream;
  }

  // stream users attendance with reference
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsersAttendanceReference(
      Room room, Attendance attendance) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);

    final stream = collection.snapshots();

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
