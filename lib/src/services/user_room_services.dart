// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user_room.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

class UserRoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // stream user room
  Stream<List<UserRoom>> streamUsersRoom(Room room) {
    final String collectionPath = "$rootRoomsCollection/${room.id}/users";

    final CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection(collectionPath);

    final Stream<List<UserRoom>> stream = collection.snapshots().map((data) =>
        data.docs.map((doc) => UserRoom.fromMap(doc.data())).toList());

    return stream;
  }

  // stream user attendance
  Stream<List<UserRoom>> streamUsersAttendance(
      Room room, Attendance attendance) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => UserRoom.fromMap(data.data())).toList());

    return stream;
  }
}
