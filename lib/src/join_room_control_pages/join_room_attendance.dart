// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class JoinRoomAttendance extends StatefulWidget {
  const JoinRoomAttendance(
      {Key? key, required this.room, required this.attendance})
      : super(key: key);

  final Room room;
  final Attendance attendance;

  @override
  State<JoinRoomAttendance> createState() => _JoinRoomAttendanceState();
}

class _JoinRoomAttendanceState extends State<JoinRoomAttendance> {
  final RoomService _roomService = RoomService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Join Room Attendance")),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  _roomService.updateAbsentUser(widget.room, widget.attendance);
                },
                child: const Text("Attend"))));
  }
}
