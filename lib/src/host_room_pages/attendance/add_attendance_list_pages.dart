// flutter
import 'package:flutter/material.dart';

// work with date
import 'package:intl/intl.dart';

// services
import 'package:atdel/src/services/attendance_services.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AddAttendanceListPage extends ConsumerStatefulWidget {
  const AddAttendanceListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddAttendanceListPage> createState() =>
      _AddAttendanceListPageState();
}

class _AddAttendanceListPageState extends ConsumerState<AddAttendanceListPage> {
  // datetime
  DateTime? startDate;
  DateTime? endDate;

  // error date
  String startDateError = '';
  String endDateError = '';

  // sign add button
  String signAddButton = '';

  // format
  final String dateFormat = "MM/dd/yyyy HH:mm";

  // get text date
  String getText(DateTime? date, String defaultText) {
    if (date == null) {
      return defaultText;
    } else {
      return DateFormat(dateFormat).format(date);
    }
  }

  // date valid
  bool dateValid() {
    if (startDate == null) {
      toastWidget("Start Date Supposed Be Valid!");
      return false;
    }
    if (endDate == null) {
      toastWidget("End Date Supposed Be Valid!");
      return false;
    }

    return true;
  }

  // date error
  bool dateError() {
    if (startDateError.isNotEmpty) {
      toastWidget(startDateError);
      return false;
    }
    if (endDateError.isNotEmpty) {
      toastWidget(endDateError);
      return false;
    }

    return true;
  }

  // add attendance
  Future addAttendanceToDatabase() async {
    if (!dateValid()) return;
    if (!dateError()) return;

    if (signAddButton == "error") return;

    final AttendanceService attendanceService = AttendanceService();
    final _selectedRoomProvider = ref.watch(selectedRoom);

    attendanceService.addAttendanceToDatabase(
        _selectedRoomProvider.room!, startDate!, endDate!);

    Navigator.pop(context);
  }

  // add attendance button
  Widget addAttendanceButton() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: signAddButton == "error" ? Colors.red : Colors.blue),
          onPressed: () async {
            addAttendanceToDatabase();
          },
          child: const Text("Add")));

  // scaffold app bar or app bar
  PreferredSizeWidget scaffoldAppBarWidget() => AppBar(
      title: const Text("Add Attendance"),
      actions: [addAttendanceButton()],
      backgroundColor: Colors.grey);

  // pick date time
  Future pickDateTime(
      BuildContext context, DateTime? date, Function callback) async {
    final DateTime? newDate = await pickDate(context, date);
    if (newDate == null) return;

    final TimeOfDay? newTime = await pickTime(context, date);
    if (newTime == null) return;

    callback(newDate, newTime);
  }

  // pick date
  Future<DateTime?> pickDate(BuildContext context, DateTime? date) async {
    final initialDate = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  // pick time
  Future<TimeOfDay?> pickTime(BuildContext context, DateTime? date) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: date != null
          ? TimeOfDay(hour: date.hour, minute: date.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  // display text
  Widget dueAttendanceText(DateTime? start, DateTime? end) {
    String startDateText = "Date Start";
    String endDateText = "Date End";

    if (start != null) startDateText = DateFormat(dateFormat).format(start);
    if (end != null) endDateText = DateFormat(dateFormat).format(end);

    if (startDateError.isNotEmpty) startDateText = startDateError;
    if (endDateError.isNotEmpty) endDateText = endDateError;

    String text = "Due Attendance\nStart: $startDateText\nEnd: $endDateText";

    return Text(text);
  }

  // Widget date start button
  Widget dateStartButton() => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          primary: startDateError.isNotEmpty ? Colors.red : Colors.blue,
        ),
        icon: const Icon(Icons.date_range),
        label: Text(getText(startDate, "Start Date")),
        onPressed: () async {
          pickDateTime(context, startDate, (newDate, newTime) {
            setState(() {
              startDate = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                newTime.hour,
                newTime.minute,
              );
            });

            if (startDate == null || endDate == null) return;

            if (startDate!.compareTo(endDate!) == 1) {
              startDateError = "Start Date must be less than End Date";
              signAddButton = "error";
              return;
            }

            endDateError = '';
            startDateError = '';
            signAddButton = '';
          });
        },
      );

  // widget date end button
  Widget dateEndButton() => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          primary: endDateError.isNotEmpty ? Colors.red : Colors.blue,
        ),
        icon: const Icon(Icons.date_range),
        label: Text(getText(endDate, "End Date")),
        onPressed: () async {
          pickDateTime(context, endDate, (newDate, newTime) {
            setState(() {
              endDate = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                newTime.hour,
                newTime.minute,
              );
            });

            if (startDate == null || endDate == null) return;

            if (endDate!.compareTo(startDate!) == -1) {
              endDateError = "End Date must be greater than Start Date";
              signAddButton = "error";
              return;
            }

            endDateError = '';
            startDateError = '';
            signAddButton = '';
          });
        },
      );

  // scaffold body or content
  Widget scaffoldBody() => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          dateStartButton(),
          dateEndButton(),
          const SizedBox(height: 100),
          dueAttendanceText(startDate, endDate)
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBarWidget(), body: scaffoldBody());
  }
}
