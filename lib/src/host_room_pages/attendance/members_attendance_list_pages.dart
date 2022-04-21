// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/host_room_pages/attendance/settings_attendance.dart';
import 'package:atdel/src/host_room_pages/attendance/members_edit_attendance.dart';

// services
import 'package:atdel/src/services/user_attendance_services.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user_attendance.dart';

class MembersAttendanceListPage extends StatefulWidget {
  const MembersAttendanceListPage(
      {Key? key, required this.room, required this.attendance})
      : super(key: key);

  final Room room;
  final Attendance attendance;

  @override
  State<MembersAttendanceListPage> createState() =>
      _MembersAttendanceListPageState();
}

class _MembersAttendanceListPageState extends State<MembersAttendanceListPage> {
  final UserAttendanceService _userAttendanceService = UserAttendanceService();

  List<UserAttendance> usersAttendance = [];

  // show members is empty and cannot be edit
  Future showMembersIsEmpty() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            "Members of the attendance must be have at least 1 for editing the member's absent!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // scaffold appbar
  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Attendance"),
        actions: const [SettingsButton()],
      );

  // floating action button
  FloatingActionButton floatingActionButton() => FloatingActionButton(
      onPressed: () {
        if (usersAttendance.isEmpty) showMembersIsEmpty();
        if (usersAttendance.isEmpty) return;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MembersEditPage(
                      usersAttendance: usersAttendance,
                    )));
      },
      child: const Icon(Icons.edit));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: scaffoldAppBar(),
      body: StreamBuilder<List<UserAttendance>>(
        stream: _userAttendanceService.streamUsersAttendance(
            widget.room, widget.attendance),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }

          final data = snapshot.data;

          if (data!.isEmpty) {
            return const Center(child: Text("No users in attendance"));
          }

          usersAttendance = data;

          return MemberView(users: data);
        },
      ),
    );
  }
}

// member info
class MemberInfoWidget extends StatelessWidget {
  const MemberInfoWidget({Key? key, required this.user}) : super(key: key);

  final UserAttendance user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl), radius: 30),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Text(user.alias)),
                const VerticalDivider(),
                Expanded(child: Text(user.email)),
                const VerticalDivider(),
                Expanded(
                    child: user.absent
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.red)),
              ]),
        ),
        const Divider(color: Colors.black)
      ],
    );
  }
}

// view of members
class MemberView extends StatelessWidget {
  const MemberView({Key? key, required this.users}) : super(key: key);

  final List<UserAttendance> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
              backgroundColor: Colors.transparent, radius: 30),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Expanded(
                    child: Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                VerticalDivider(),
                Expanded(
                    child: Text("Email",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                VerticalDivider(),
                Expanded(
                    child: Text("Absent",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
        ),
        const Divider(color: Colors.black),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserAttendance currentUser = users[index];

              return MemberInfoWidget(user: currentUser);
            },
          ),
        ),
      ],
    );
  }
}

// settings button
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const SettingsAttendancePage())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );
  }
}
