// flutter
import 'package:flutter/material.dart';

// custom widgets
import 'package:floating_action_bubble/floating_action_bubble.dart';

// pages
import 'package:atdel/src/host_room_control_pages/add_attendance_list_pages.dart';
import 'package:atdel/src/host_room_control_pages/members_attendance_list_pages.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class AttedanceListScreen extends StatefulWidget {
  const AttedanceListScreen({Key? key, required this.room}) : super(key: key);

  // final String roomId;
  final Room room;

  @override
  State<AttedanceListScreen> createState() => _AttedanceListScreenState();
}

class _AttedanceListScreenState extends State<AttedanceListScreen>
    with SingleTickerProviderStateMixin {
  // floating action button animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // services
  final RoomService _roomService = RoomService();

  @override
  void initState() {
    super.initState();

    // floating action button animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  // attendance list button widget
  Widget attendanceListButtonWidget(Attendance attendance) {
    // widgets parameters
    const IconData icon = Icons.date_range;

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MembersAttendanceListPage(
                    room: widget.room, attendance: attendance)));
      },
      leading: const Icon(icon),
      title: Column(children: [
        Text("Start: " + attendance.dateStart.toString()),
        Text("End: " + attendance.dateEnd.toString())
      ]),
    );
  }

  // floating action button of attendance list screen
  Widget floatingActionButtonWidget() {
    // add button
    Bubble addAttendanceButton = Bubble(
        icon: Icons.add,
        iconColor: Colors.white,
        title: "Add",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAttendanceListPage(
                        room: widget.room,
                      )));
        });

    return FloatingActionBubble(
        items: [addAttendanceButton],
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        backGroundColor: Colors.blue,
        animation: _animation,
        iconData: Icons.menu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButtonWidget(),
        body: StreamBuilder<List<Attendance>>(
          stream: _roomService.streamAttendanceList(widget.room.id),
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
