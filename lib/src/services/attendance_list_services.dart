// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';

class AttendanceListService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

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
}
