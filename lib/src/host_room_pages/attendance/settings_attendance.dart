// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/attendance/widgets/settings_attendance.dart';

// settings attendance page
class SettingsAttendancePage extends StatelessWidget {
  const SettingsAttendancePage({Key? key}) : super(key: key);

  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Attendance Settings"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentSettings());
  }
}

// content settings
class ContentSettings extends StatelessWidget {
  const ContentSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text(
            "DANGER ZONE",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          DeleteAttendanceButton()
        ],
      ),
    );
  }
}