// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// widgets
import 'package:atdel/src/join_room_pages/attendance/widgets/attendance.dart';

// join room
class JoinRoomAttendance extends ConsumerStatefulWidget {
  const JoinRoomAttendance({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinRoomAttendance> createState() => _JoinRoomAttendanceState();
}

class _JoinRoomAttendanceState extends ConsumerState<JoinRoomAttendance> {
  @override
  Widget build(BuildContext context) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final attendanceWithMl = selectedRoomProvider.room!.attendanceWithMl;
    return Scaffold(
      appBar: AppBar(title: const Text("Join Room Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: attendanceWithMl ? const AttendWithML() : const AttendWithNoMl() 
      ),
    );
  }
}