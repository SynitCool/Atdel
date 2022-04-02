// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final DateTime dateStart;
  final DateTime dateEnd;
  final String id;

  Attendance(
      {required this.dateStart, required this.dateEnd, required this.id});

  factory Attendance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();

    final DateTime convertDateStart = doc["date_start"].toDate();
    final DateTime convertDateEnd = doc["date_end"].toDate();

    return Attendance(
        dateStart: convertDateStart, dateEnd: convertDateEnd, id: data!["id"]);
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    final DateTime convertDateStart = map["date_start"].toDate();
    final DateTime convertDateEnd = map["date_end"].toDate();

    return Attendance(
        dateStart: convertDateStart, dateEnd: convertDateEnd, id: map["id"]);
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
}
