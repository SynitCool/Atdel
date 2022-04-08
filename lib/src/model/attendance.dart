// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final DateTime dateStart;
  final DateTime dateEnd;
  final String id;

  bool attendanceActive = false;

  Attendance(
      {required this.dateStart,
      required this.dateEnd,
      required this.id,
      this.attendanceActive = false});

  factory Attendance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    final DateTime convertDateStart = doc["date_start"].toDate();
    final DateTime convertDateEnd = doc["date_end"].toDate();

    final bool active = checkAttendanceActive(convertDateStart, convertDateEnd);

    return Attendance(
        dateStart: convertDateStart,
        dateEnd: convertDateEnd,
        id: data!["id"],
        attendanceActive: active);
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    final DateTime convertDateStart = map["date_start"].toDate();
    final DateTime convertDateEnd = map["date_end"].toDate();

    final bool active = checkAttendanceActive(convertDateStart, convertDateEnd);

    return Attendance(
        dateStart: convertDateStart,
        dateEnd: convertDateEnd,
        id: map["id"],
        attendanceActive: active);
  }

  Map<String, dynamic> toMap() {
    final Timestamp convertDateStart = Timestamp.fromDate(dateStart);
    final Timestamp convertDateEnd = Timestamp.fromDate(dateEnd);

    return {
      "date_start": convertDateStart,
      "date_end": convertDateEnd,
      "id": id
    };
  }

  // check attendance active
  static bool checkAttendanceActive(DateTime dateStart, DateTime dateEnd) {
    final DateTime currentDateTime = DateTime.now();
    if (currentDateTime.compareTo(dateStart) == -1) return false;
    if (currentDateTime.compareTo(dateEnd) == 1) return false;

    return true;
  }
}
