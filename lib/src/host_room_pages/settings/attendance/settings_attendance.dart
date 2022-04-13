// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/attendance_services.dart';

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

// delete attendance button
class DeleteAttendanceButton extends ConsumerWidget {
  const DeleteAttendanceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedRoomProvider = ref.watch(selectedRoom);

    // services
    final AttendanceService _attendanceService = AttendanceService();
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete),
      style: ElevatedButton.styleFrom(primary: Colors.red),
      label: const Text("Delete Attendance"),
      onPressed: () {
        _attendanceService.deleteAttendance(_selectedRoomProvider.room!,
            _selectedAttendanceProvider.attendance!);

        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}
