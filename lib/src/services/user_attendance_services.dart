// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_attendance.dart';
import 'package:atdel/src/model/user.dart';

class UserAttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // update absent user
  Future updateAbsentUser(
      User currentUser, Room room, Attendance attendance) async {
    // collection
    final collection = _db.collection(
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users");

    final doc = collection.doc(currentUser.uid);

    // update absent user
    final getDoc = await doc.get();

    final UserAttendance userAttendance = UserAttendance.fromMap(getDoc.data()!);

    if (userAttendance.uid != currentUser.uid) return;

    userAttendance.setAbsent = false;

    Map<String, dynamic> userMap = userAttendance.toMap();

    await doc.update(userMap);
  }

  // get users attendance
  Future<List<UserAttendance>> getUsersAttendance(
      Room room, Attendance attendance) async {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(collectionPath);

    final getCollection = await collection.get();

    return getCollection.docs
        .map((data) => UserAttendance.fromMap(data.data()))
        .toList();
  }

  // update user attendance
  Future updateUserAttendance(UserAttendance oldUser, UserAttendance newUser,
      Room room, Attendance attendance) async {
    // collection
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(oldUser.uid);

    // update old user to new user
    await doc.set(newUser.toMap());
  }

  // update users attendance
  Future updateUsersAttendance(List<UserAttendance> newUsersAttendance,
      Room room, Attendance attendance) async {
    // collection
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";

    final collection = _db.collection(collectionPath);

    // update all users attendance
    for (int i = 0; i < newUsersAttendance.length; i++) {
      final doc = collection.doc(newUsersAttendance[i].uid);

      await doc.set(newUsersAttendance[i].toMap());
    }
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

  // stream user attendance
  Stream<UserAttendance> streamUserAttendance(
      User user, Room room, Attendance attendance) {
    // user attendance
    final collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);
    final doc = collection.doc(user.uid);

    // stream
    final stream =
        doc.snapshots().map((data) => UserAttendance.fromMap(data.data()!));

    return stream;
  }

  // stream user attendance
  Stream<List<UserAttendance>> streamUsersAttendance(
      Room room, Attendance attendance) {
    final String collectionPath =
        "$rootRoomsCollection/${room.id}/attendance_list/${attendance.id}/users";
    final collection = _db.collection(collectionPath);

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => UserAttendance.fromMap(data.data())).toList());

    return stream;
  }
}