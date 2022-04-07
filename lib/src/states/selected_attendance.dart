// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';

class SelectedAttendance extends ChangeNotifier {
  Attendance? attendance;

  bool attendanceActive = false;
  final DateTime currentDateTime = DateTime.now();

  // check if attendance active
  Future checkAttendanceActive() async {
    if (currentDateTime.compareTo(attendance!.dateStart) == -1) return;

    if (currentDateTime.compareTo(attendance!.dateEnd) == 1) return;

    attendanceActive = true;
  }

  // set attendance
  set setAttendance(Attendance newAttendance) {
    attendance = newAttendance;
    checkAttendanceActive();
    notifyListeners();
  }
}
