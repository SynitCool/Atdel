// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart';

// services
import 'package:atdel/src/services/room_services.dart';

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
  final RoomService _roomService = RoomService();

  // scaffold appbar
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Attendance"));

  // member info button
  Widget memberInfo(User user) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl), radius: 30),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Text(user.displayName)),
                  const VerticalDivider(),
                  Expanded(child: Text(user.email)),
                  const VerticalDivider(),
                  Expanded(child: Text(user.absent.toString())),
                ]),
          ),
          const Divider(color: Colors.black)
        ],
      );

  // scaffold body
  Widget scaffoldBody(List<User> users) => Column(
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
                final User currentUser = users[index];

                return memberInfo(currentUser);
              },
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: StreamBuilder<List<User>>(
        stream:
            _roomService.streamUsersAttendance(widget.room, widget.attendance),
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

          return scaffoldBody(data);
        },
      ),
    );
  }
}
