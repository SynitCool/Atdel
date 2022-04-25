// firebase
import 'package:atdel/src/model/user_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// services
import 'package:atdel/src/services/user_attendance_services.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';

class AttendanceListService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // get attendance list
  Future<Map<Attendance, List<UserAttendance>>> getAttendanceListUsers(Room room) async {
    final UserAttendanceService userAttendanceService = UserAttendanceService();

    Map<Attendance, List<UserAttendance>> attendanceListUsers = {};

    final attendancesList = await getAttendanceList(room);

    for (final attendance in attendancesList) {
      final usersAttendance =
          await userAttendanceService.getUsersAttendance(room, attendance);

      attendanceListUsers[attendance] = usersAttendance;
    }
    
    return attendanceListUsers;
  }

  // delete all attendance list
  Future deleteAttendancesList(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> attendanceListCollection =
        _db.collection("$rootRoomsCollection/${room.id}/attendance_list");

    // delete all attendance list
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

  // get attendance list
  Future<List<Attendance>> getAttendanceList(Room room) async {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list";
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final getCollection =
        await collection.orderBy("date_start", descending: true).get();

    return getCollection.docs
        .map((data) => Attendance.fromMap(data.data()))
        .toList();
  }
}
