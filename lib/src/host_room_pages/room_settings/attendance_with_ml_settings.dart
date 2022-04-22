// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/attendance_with_ml_settings.dart';

// attendance with ml page
class AttendanceWithMlOptionPage extends StatefulWidget {
  const AttendanceWithMlOptionPage({Key? key}) : super(key: key);

  @override
  State<AttendanceWithMlOptionPage> createState() =>
      _AttendanceWithMlOptionPageState();
}

class _AttendanceWithMlOptionPageState
    extends State<AttendanceWithMlOptionPage> {
  bool attendanceWithMlValue = false;

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [
          UpdateAttendanceWithMlButton(attendanceWithMl: attendanceWithMlValue)
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const OldAttendanceWithMlSetting(),
            const SizedBox(height: 5),
            CheckboxListTile(
                shape: const OutlineInputBorder(),
                value: attendanceWithMlValue,
                title: const Text("New Attendance With ML Settings"),
                subtitle: const Text("Take attendance with machine learning."),
                onChanged: (value) => setState(() {
                      attendanceWithMlValue = value!;
                    }))
          ],
        ),
      ),
    );
  }
}