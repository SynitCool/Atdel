// dart
import 'dart:io';

// excel
import 'package:excel/excel.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/attendance_list_services.dart';

class ConvertToExcelService {
  final Excel excel = Excel.createExcel();

  // convert with attendance list
  Future convertByAttendanceList(Room room) async {
    final AttendanceListService attendanceListService = AttendanceListService();

    final attendanceUsers = await attendanceListService.getAttendanceListUsers(room);

    print("convert");
  }
}
