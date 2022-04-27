// flutter
import 'package:flutter/material.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/attendance_with_ml_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/widgets/room_name_settings.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// update room button
class UpdateRoomButton extends ConsumerWidget {
  const UpdateRoomButton({Key? key, required this.newRoomInfo})
      : super(key: key);

  final Map<String, dynamic> newRoomInfo;

  // check room name valid
  bool newRoomNameValid(String roomName) {
    if (roomName.isEmpty) return false;
    if (roomName.length < 4) return false;
    if (roomName.length > 12) return false;

    return true;
  }

  // check if new data is valid
  bool newDataValid() {
    if (newRoomInfo["room_name"] == null) return false;

    return true;
  }

  // data not valid error
  Future showDataNotValidError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text("Data input must be valid!"),
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
    final selectedRoomProvider = ref.watch(selectedRoom);
    final roomService = RoomService();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          if (!newDataValid()) showDataNotValidError(context);
          if (!newDataValid()) return;

          if (!newRoomNameValid(newRoomInfo["room_name"])) return;

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setRoomName = newRoomInfo["room_name"];
          selectedRoomProvider.room!.setAttendanceWithMl =
              newRoomInfo["attendance_with_ml"];

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}

// room name settings
class RoomNameSettings extends StatefulWidget {
  const RoomNameSettings({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  State<RoomNameSettings> createState() => _RoomNameSettingsState();
}

class _RoomNameSettingsState extends State<RoomNameSettings> {
  // controller
  final TextEditingController newRoomNameController = TextEditingController();
  String newRoomNameText = '';

  @override
  void dispose() {
    newRoomNameController.dispose();
    super.dispose();
  }

  // error text field
  String? get errorText {
    final String text = newRoomNameController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OldRoomTextField(),
        TextField(
          controller: newRoomNameController,
          decoration: InputDecoration(
              label: const Text("New Room Name"), errorText: errorText),
          onChanged: (text) => setState(() {
            newRoomNameText = text;
            widget.callback(newRoomNameText);
          }),
        ),
      ],
    );
  }
}

// private room settings
class AttendanceWithMlSettings extends StatefulWidget {
  const AttendanceWithMlSettings({Key? key, required this.callback})
      : super(key: key);

  final Function callback;

  @override
  State<AttendanceWithMlSettings> createState() => _AttendanceWithMlSettings();
}

class _AttendanceWithMlSettings extends State<AttendanceWithMlSettings> {
  bool attendanceWithMlValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  widget.callback(attendanceWithMlValue);
                }))
      ],
    );
  }
}
