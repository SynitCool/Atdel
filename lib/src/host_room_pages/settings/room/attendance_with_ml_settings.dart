// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// model
import 'package:atdel/src/model/room.dart';

// attendance with ml page
class AttendanceWithMlOptionPage extends StatefulWidget {
  const AttendanceWithMlOptionPage({Key? key}) : super(key: key);

  @override
  State<AttendanceWithMlOptionPage> createState() => _AttendanceWithMlOptionPageState();
}

class _AttendanceWithMlOptionPageState extends State<AttendanceWithMlOptionPage> {
  bool attendanceWithMlValue = false;

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [
          UpdateAttendanceWithMlButton(attendanceWithMl: attendanceWithMlValue)
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const OldAttendanceWithMlSetting(),
            const SizedBox(height: 5),
            CheckboxListTile(
                shape: const OutlineInputBorder(),
                value: attendanceWithMlValue,
                title: const Text("New Attendance With ML Settings"),
                subtitle: const Text("Take attendance with machine learning."),
                onChanged: (value) => setState(() {
                      attendanceWithMlValue = value!;
                    }))
          ],
        ),
      ),
    );
  }
}

// old attendance with ml settings
class OldAttendanceWithMlSetting extends ConsumerWidget {
  const OldAttendanceWithMlSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final attendanceWithMlValue = selectedRoomProvider.room!.attendanceWithMl;
    return CheckboxListTile(
        shape: const OutlineInputBorder(),
        value: attendanceWithMlValue,
        title: const Text("Old Attendance With ML Settings"),
        subtitle: const Text("Take attendance with machine learning."),
        onChanged: (value) {});
  }
}

// update room button
class UpdateAttendanceWithMlButton extends ConsumerWidget {
  const UpdateAttendanceWithMlButton({Key? key, required this.attendanceWithMl})
      : super(key: key);

  final bool attendanceWithMl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final roomService = RoomService();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          if (selectedRoomProvider.room!.attendanceWithMl == attendanceWithMl) {
            Navigator.pop(context);
          }
          
          if (selectedRoomProvider.room!.attendanceWithMl == attendanceWithMl) {
            return;
          }

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setAttendanceWithMl = attendanceWithMl;

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          Navigator.pop(context);
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}
