// dart
import 'dart:io';

// path
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path/path.dart';

// permission
import 'package:permission_handler/permission_handler.dart';

// excel
import 'package:excel/excel.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user_attendance.dart';
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/attendance_list_services.dart';
import 'package:atdel/src/services/user_room_services.dart';

class ConvertToExcelService {
  final Excel excel = Excel.createExcel();

  final String mainSheet = "main_sheet";

  // convert with attendance list
  Future convertByAttendanceList(Room room) async {
    // get users attendance and users room
    final AttendanceListService attendanceListService = AttendanceListService();
    final UserRoomService userRoomService = UserRoomService();

    final Map<Attendance, List<UserAttendance>> attendanceUsers =
        await attendanceListService.getAttendanceListUsers(room);

    final usersRoom = await userRoomService.getUsersRoom(room);

    // make excel in main_sheet
    await addListNumber(usersRoom.length, mainSheet);

    final uidRowNum = await addUsersRoom(usersRoom, mainSheet);

    await addDateAbsent(attendanceUsers, mainSheet, uidRowNum);

    // encode to excel
    saveToDownloadDirectory(excel.encode()!, "test_excel_2.xlsx");
  }

  // add list number to excel
  Future addListNumber(int length, String nameSheet) async {
    // get sheet
    final sheet = excel[nameSheet];

    // excel column
    var noCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    noCell.value = "No";

    // add number list
    for (var i = 0; i < length; i++) {
      var numberCell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1));
      numberCell.value = i + 1;
    }
  }

  // add users room
  Future<Map<String, int>> addUsersRoom(
      List<UserRoom> usersRoom, String nameSheet) async {
    // make users room uid and row num
    Map<String, int> uidRowNum = {};

    // get sheet
    final sheet = excel[nameSheet];

    // excel column
    var noCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    noCell.value = "Users";

    // add number list
    for (var i = 0; i < usersRoom.length; i++) {
      var numberCell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1));

      numberCell.value = usersRoom[i].alias;

      uidRowNum[usersRoom[i].uid] = i + 1;
    }

    return uidRowNum;
  }

  // make date absent room
  Future addDateAbsent(Map<Attendance, List<UserAttendance>> attendanceUsers,
      String nameSheet, Map<String, int> uidRowNum) async {
    // excel sheet
    final sheet = excel[nameSheet];

    // add date column
    int columnStart = 2;
    for (final attendanceKey in attendanceUsers.keys) {
      Data attendanceCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: columnStart, rowIndex: 0));

      final dateSign = "${attendanceKey.dateStart} - ${attendanceKey.dateEnd}";

      attendanceCell.value = dateSign;
      for (int i = 0; i < attendanceUsers[attendanceKey]!.length; i++) {
        final userRowIndex = uidRowNum[attendanceUsers[attendanceKey]![i].uid];
        Data userCell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: columnStart, rowIndex: userRowIndex));

        userCell.value = attendanceUsers[attendanceKey]![i].absent.toString();
      }

      columnStart++;
    }
  }

  // save to download directory
  Future saveToDownloadDirectory(
      List<int> encodedExcel, String nameFile) async {
    // check permission
    const permission = Permission.storage;

    if (await permission.isDenied) {
      final permissionStatus = await permission.request();

      if (permissionStatus.isDenied) return;
    }

    final downloadsPath = await DownloadsPathProvider.downloadsDirectory;
    final downloadsFilePath = join(downloadsPath!.path, nameFile);

    final excelFile = File(downloadsFilePath);

    await excelFile.writeAsBytes(encodedExcel);
  }
}
