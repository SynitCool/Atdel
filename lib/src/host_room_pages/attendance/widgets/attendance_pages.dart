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

// date
import 'package:intl/intl.dart';

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
        shape: const OutlineInputBorder(),
        onTap: () {
          _selectedAttendanceProvider.setAttendance = attendance;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MembersAttendanceListPage(
                      room: _selectedRoomProvider.room!,
                      attendance: attendance)));
        },
        leading: const Icon(Icons.date_range, color: Colors.white),
        tileColor: attendance.attendanceActive ? Colors.green : Colors.red,
        title: FittedBox(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Start: " +
                DateFormat('EEEE, d MMM, yyyy h:mm a')
                    .format(attendance.dateStart), style: const TextStyle(color: Colors.white)),
            Text("End: " +
                DateFormat('EEEE, d MMM, yyyy h:mm a')
                    .format(attendance.dateEnd), style: const TextStyle(color: Colors.white))
          ]),
        ),
      ),
    );
  }
}

// filtered sections
class FilteredSections extends StatelessWidget {
  const FilteredSections({
    Key? key,
    required this.filterButtons
  }) : super(key: key);

  final List<PopupMenuEntry<dynamic>> filterButtons;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("Filter by"),
        PopupMenuButton(
          icon: const Icon(Icons.filter_list),
          itemBuilder: (context) {
            return filterButtons;
          },
        )
      ],
    );
  }
}
