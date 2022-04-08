// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_attendance.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserAttendance> getUserAttendance(
      User user, Room room, Attendance attendance) async {
    // user attendance
    final collectionPath =
        "rooms/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);
    final doc = collection.doc(user.uid);

    // get doc
    final getDoc = await doc.get();
    final UserAttendance userAttendance = UserAttendance.fromFirestore(getDoc);

    // check if absent
    return userAttendance;  
  }
}
