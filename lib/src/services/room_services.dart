// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart' as model;

// other
import 'package:random_string_generator/random_string_generator.dart';

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "new_rooms";
  final String rootUsersCollection = "new_users";
  final String rootCodesCollection = "new_codes";

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
  Future addRoomToDatabase(String roomName) async {
    // generator
    final RandomStringGenerator generator =
        RandomStringGenerator(fixedLength: 6);

    generator.hasSymbols = false;
    generator.hasDigits = false;

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

    // settings room object and add to room Doc
    Room room = Room.fromFirebaseAuth(authUser);

    room.setRoomDesc = "<h1>Welcome</h1>";
    room.setRoomName = roomName;
    room.setId = roomDoc.id;
    room.setRoomCode = generator.generate();

    final Map<String, dynamic> roomMap = room.toMap();

    await roomDoc.set(roomMap);

    // update users rooms
    final DocumentSnapshot<Map<String, dynamic>> getDoc = await usersDoc.get();

    model.User user = model.User.fromFirestore(getDoc);

    user.roomReferences.add(roomDoc);

    Map<String, dynamic> usersInfo = user.toMap();

    await usersDoc.update(usersInfo);

    // add to room codes
    final DocumentSnapshot<Map<String, dynamic>> getCodes =
        await codesDoc.get();

    final Map<String, dynamic>? codesMap = getCodes.data();

    codesMap!.addAll({room.roomCode: roomDoc});

    await codesDoc.update(codesMap);
  }

  // stream global rooms
  Stream<List<Room>> streamGlobalRooms() {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootRoomsCollection);

    final Stream<List<Room>> snapshot = collection.snapshots().map(
        (snap) => snap.docs.map((data) => Room.fromMap(data.data())).toList());

    return snapshot;
  }

  // stream user rooms
  Stream<Room> streamReferenceRoom(
      DocumentReference<Map<String, dynamic>> reference) {
    final Stream<Room> snapshot =
        reference.snapshots().map((data) => Room.fromMap(data.data()!));

    return snapshot;
  }

  // join room with code
  Future joinRoomWithCode(String code) async {
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

    // update the user references
    final DocumentSnapshot<Map<String, dynamic>> getUsersDoc =
        await usersDoc.get();

    final model.User userModel = model.User.fromFirestore(getUsersDoc);

    userModel.roomReferences.add(roomCodesMap[code]);

    Map<String, dynamic> userModelInfo = userModel.toMap();

    await usersDoc.update(userModelInfo);
  }
}
