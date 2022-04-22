// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/attendance_services.dart';


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
