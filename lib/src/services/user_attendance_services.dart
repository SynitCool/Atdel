// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

class UserAttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // stream users attendance with reference
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsersAttendanceReference(
      Room room, Attendance attendance) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);

    final stream = collection.snapshots();

    return stream;
  }
}
