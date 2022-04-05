// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';

class SelectedAttendance extends ChangeNotifier {
  Attendance? attendance;

  // set attendance
  set setAttendance(Attendance newAttendance) {
    attendance = newAttendance;
    notifyListeners();
  }
}
