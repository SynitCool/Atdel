// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/join_room_control_pages/join_room_attendance.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class JoinRoomAttendanceList extends StatefulWidget {
  const JoinRoomAttendanceList({Key? key, required this.room})
      : super(key: key);

  // final String roomId;
  final Room room;

  @override
  State<JoinRoomAttendanceList> createState() => _JoinRoomAttendanceListState();
}

class _JoinRoomAttendanceListState extends State<JoinRoomAttendanceList>
    with SingleTickerProviderStateMixin {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // services
  final RoomService _roomService = RoomService();

  // attendance list button widget
  Widget attendanceListButtonWidget(Attendance attendance) {
    // widgets parameters
    const IconData icon = Icons.date_range;

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JoinRoomAttendance(
                    room: widget.room, attendance: attendance)));
      },
      leading: const Icon(icon),
      title: Column(children: [
        Text("Start: " + attendance.dateStart.toString()),
        Text("End: " + attendance.dateEnd.toString())
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Attendance>>(
      stream: _roomService.streamAttendanceList(widget.room),
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

              return attendanceListButtonWidget(currentData);
            });
      },
    ));
  }
}
