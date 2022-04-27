// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/settings.dart';

// set room pages
class SetRoomPages extends ConsumerStatefulWidget {
  const SetRoomPages({Key? key}) : super(key: key);

  @override
  ConsumerState<SetRoomPages> createState() => _SetRoomPagesState();
}

class _SetRoomPagesState extends ConsumerState<SetRoomPages> {
  // room info set
  Map<String, dynamic> newRoomInfo = {
    "room_name": '',
    "private_room": false,
    "attendance_with_ml": false
  };

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [UpdateRoomButton(newRoomInfo: newRoomInfo)],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: scaffoldAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text("Room Info Settings",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              RoomNameSettings(callback: (newRoomName) {
                setState(() {
                  newRoomInfo["room_name"] = newRoomName;
                });
              }),
              const SizedBox(height: 30),
              AttendanceWithMlSettings(callback: (newAttendanceWithMl) {
                setState(() {
                  newRoomInfo["attendance_with_ml"] = newAttendanceWithMl;
                });
              })
            ],
          ),
        ));
  }
}