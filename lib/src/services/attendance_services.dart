// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_attendance.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

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
    final _userRoomService = UserRoomService();
    final roomUsers = _userRoomService.streamUsersRoom(room);

    roomUsers.forEach((elements) async {
      for (final element in elements) {
        if (room.hostUid == element.uid) continue;

        final elementDoc = attendanceUsersCollection.doc(element.uid);

        final userAttendance = UserAttendance.fromUserRoom(element);

        final map = userAttendance.toMap();

        await elementDoc.set(map);
      }
    });
  }
}
