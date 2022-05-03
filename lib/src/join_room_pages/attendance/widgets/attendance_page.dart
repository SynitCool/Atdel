// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/join_room_pages/attendance/join_room_attendance.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/user_attendance.dart';

// services
import 'package:atdel/src/services/user_attendance_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/current_user_providers.dart';

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';

// date
import 'package:intl/intl.dart';

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

  // attendance valid
  bool attendanceValid() {
    if (!attendance.attendanceActive) {
      toastWidget("Attendance Is Not Active!");
      return false;
    }

    return true;
  }

  // user attendance valid
  bool userAttendanceValid(UserAttendance userAttendance) {
    if (!userAttendance.absent) {
      toastWidget("You're Not Absent For This Attendance!");

      return false;
    }

    return true;
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
          if (snapshot.data == null) return const Text("");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: const OutlineInputBorder(),
              tileColor: listTileColor(data!),
              onTap: () {
                if (!userAttendanceValid(data)) return;
                if (!attendanceValid()) return;

                _selectedAttendanceProvider.setAttendance = attendance;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinRoomAttendance()));
              },
              leading: const Icon(Icons.date_range, color: Colors.white),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  "Start: " +
                      DateFormat('EEEE, d MMM, yyyy h:mm a')
                          .format(attendance.dateStart),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                    "End: " +
                        DateFormat('EEEE, d MMM, yyyy h:mm a')
                            .format(attendance.dateEnd),
                    style: const TextStyle(color: Colors.white))
              ]),
            ),
          );
        });
  }
}

// filtered sections
class FilteredSections extends StatelessWidget {
  const FilteredSections({Key? key, required this.filterButtons})
      : super(key: key);

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
