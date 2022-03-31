import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// personal packages
import 'package:databases/firebase_firestore.dart' as model;

class AddAttendanceListPage extends StatefulWidget {
  const AddAttendanceListPage(
      {Key? key, required this.roomId, required this.userUid})
      : super(key: key);

  final String roomId;
  final String userUid;

  @override
  State<AddAttendanceListPage> createState() => _AddAttendanceListPageState();
}

class _AddAttendanceListPageState extends State<AddAttendanceListPage> {
  // datetime
  DateTime? startDate;
  DateTime? endDate;

  // attendance database
  late model.AttendanceList _attendance;

  // error date
  String startDateError = '';
  String endDateError = '';

  // sign add button
  String signAddButton = '';

  // format
  final String dateFormat = "MM/dd/yyyy HH:mm";

  @override
  void initState() {
    super.initState();

    _attendance =
        model.AttendanceList(roomId: widget.roomId, userUid: widget.userUid);
  }

  // get text date
  String getText(DateTime? date, String defaultText) {
    if (date == null) {
      return defaultText;
    } else {
      return DateFormat(dateFormat).format(date);
    }
  }

  // add attendance
  Future addAttendanceToDatabase() async {
    if (startDate == null || endDate == null) return;
    if (signAddButton == "error") return;

    _attendance.addAttendance(startDate!, endDate!, roomId: widget.roomId, userUid: widget.userUid);

    Navigator.pop(context);
  }

  // scaffold app bar or app bar
  PreferredSizeWidget scaffoldAppBarWidget() {
    // appbar parameters
    const Color backgroundColor = Colors.grey;

    // actions button
    final Widget addAttendance = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: signAddButton == "error" ? Colors.red : Colors.blue),
            onPressed: () async {
              addAttendanceToDatabase();
            },
            child: const Text("Add")));

    return AppBar(
        title: const Text("Add Attendance"),
        actions: [addAttendance],
        backgroundColor: backgroundColor);
  }

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

  // scaffold body or content
  Widget scaffoldBody() {
    // date buttons
    Widget dateStart = ElevatedButton.icon(
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

    Widget dateEnd = ElevatedButton.icon(
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

    // additional widget
    const SizedBox spacerHeight100 = SizedBox(height: 100);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        dateStart,
        dateEnd,
        spacerHeight100,
        dueAttendanceText(startDate, endDate)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBarWidget(), body: scaffoldBody());
  }
}
