// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/join_room_control_pages/join_room_attendance.dart';

// model
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';

// join attendance page
class JoinRoomAttendanceList extends ConsumerStatefulWidget {
  const JoinRoomAttendanceList({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinRoomAttendanceList> createState() =>
      _JoinRoomAttendanceListState();
}

class _JoinRoomAttendanceListState
    extends ConsumerState<JoinRoomAttendanceList> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // services
  final RoomService _roomService = RoomService();

  @override
  Widget build(BuildContext context) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Scaffold(
        body: StreamBuilder<List<Attendance>>(
      stream: _roomService.streamAttendanceList(_selectedRoomProvider.room!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        if (data!.isEmpty) {
          return const Center(child: Text("No attendance"));
        }

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final currentData = data[index];

              return AttendanceListButtonWidget(attendance: currentData);
            });
      },
    ));
  }
}

// attendance button
class AttendanceListButtonWidget extends ConsumerWidget {
  const AttendanceListButtonWidget({Key? key, required this.attendance})
      : super(key: key);

  final Attendance attendance;

  // attendance active error
  Future attendanceActiveError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text("The attendance is not active !."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);

    return ListTile(
      tileColor: attendance.attendanceActive ? Colors.green : Colors.red,
      onTap: () {
        if (!attendance.attendanceActive) attendanceActiveError(context);
        if (!attendance.attendanceActive) return;

        _selectedAttendanceProvider.setAttendance = attendance;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const JoinRoomAttendance()));
      },
      leading: const Icon(Icons.date_range, color: Colors.white),
      title: Column(children: [
        Text(
          "Start: " + attendance.dateStart.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        Text("End: " + attendance.dateEnd.toString(),
            style: const TextStyle(color: Colors.white))
      ]),
    );
  }
}
