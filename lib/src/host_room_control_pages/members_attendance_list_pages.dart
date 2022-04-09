// flutter
import 'package:atdel/src/services/user_room_services.dart';
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user_room.dart';

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
  final UserRoomService _userRoomService = UserRoomService();

  // scaffold appbar
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Attendance"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: StreamBuilder<List<UserRoom>>(
        stream:
            _userRoomService.streamUsersAttendance(widget.room, widget.attendance),
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

          return MemberView(users: data);
        },
      ),
    );
  }
}

// member info
class MemberInfoWidget extends StatelessWidget {
  const MemberInfoWidget({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

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

  final List<UserRoom> users;

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
              final UserRoom currentUser = users[index];

              return MemberInfoWidget(user: currentUser);
            },
          ),
        ),
      ],
    );
  }
}
