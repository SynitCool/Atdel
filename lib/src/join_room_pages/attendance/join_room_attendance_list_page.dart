// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/attendance_list_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// widgets
import 'package:atdel/src/join_room_pages/attendance/widgets/attendance_page.dart';

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
      stream: _attendanceListService
          .streamAttendanceList(_selectedRoomProvider.room!),
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