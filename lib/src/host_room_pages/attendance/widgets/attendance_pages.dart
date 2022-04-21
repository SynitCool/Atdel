// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/attendance.dart';

// pages
import 'package:atdel/src/host_room_pages/attendance/members_attendance_list_pages.dart';

// attendance page loading screen
class AttendancePageLoadingScreen extends StatelessWidget {
  const AttendancePageLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CircularProgressIndicator());
  }
}

// attendance page error scene
class AttendancePageErrorScreen extends StatelessWidget {
  const AttendancePageErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Error"),
    );
  }
}

// attendance button
class AttendanceButtonWidget extends ConsumerWidget {
  const AttendanceButtonWidget({Key? key, required this.attendance})
      : super(key: key);

  final Attendance attendance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          _selectedAttendanceProvider.setAttendance = attendance;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MembersAttendanceListPage(
                      room: _selectedRoomProvider.room!,
                      attendance: attendance)));
        },
        leading: const Icon(Icons.date_range),
        title: Column(children: [
          Text("Start: " + attendance.dateStart.toString()),
          Text("End: " + attendance.dateEnd.toString())
        ]),
      ),
    );
  }
}
