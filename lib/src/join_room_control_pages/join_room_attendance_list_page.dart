// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/join_room_control_pages/join_room_attendance.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_attendance.dart';

// services
import 'package:atdel/src/services/user_attendance_services.dart';
import 'package:atdel/src/services/attendance_list_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/current_user_providers.dart';

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
  final AttendanceListService _attendanceListService = AttendanceListService();

  @override
  Widget build(BuildContext context) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Scaffold(
        body: StreamBuilder<List<Attendance>>(
      stream: _attendanceListService.streamAttendanceList(_selectedRoomProvider.room!),
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

  // scenes
  final Widget loadingScene = const Center(
    child: CircularProgressIndicator(),
  );
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

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

  // attendance user not absent
  Future attendanceNotAbsentError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "HURRAY!",
          style: TextStyle(color: Colors.yellow),
        ),
        content: const Text("You are not absent for this attendance!."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // get list tile color
  Color listTileColor(UserAttendance userAttendance) {
    if (!userAttendance.absent) return Colors.yellow;
    if (attendance.attendanceActive) return Colors.green;

    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _currentUserProvider = ref.watch(currentUser);

    // services
    final _userAttendanceService = UserAttendanceService();

    return StreamBuilder<UserAttendance>(
        stream: _userAttendanceService.streamUserAttendance(
            _currentUserProvider.user!,
            _selectedRoomProvider.room!,
            attendance),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return ListTile(
            tileColor: listTileColor(data!),
            onTap: () {
              if (!data.absent) attendanceNotAbsentError(context);
              if (!data.absent) return;
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
        });
  }
}
