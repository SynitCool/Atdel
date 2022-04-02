import 'package:cloud_firestore/cloud_firestore.dart';
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
  // attendance profile
  // late Timestamp dateEnd;
  // late Timestamp dateStart;

  // late List<dynamic> users;

  @override
  void initState() {
    super.initState();

    // dateEnd = widget.attendanceInfo["date_end"];
    // dateStart = widget.attendanceInfo["date_start"];
    // users = widget.attendanceInfo["users"];
  }

  PreferredSizeWidget scaffoldAppBar() {
    return AppBar(title: const Text("Attendance"));
  }

  // Widget memberInfo(Map<String, dynamic> user) {
  //   final String photoUrl = user["user_image_url"];
  //   final String email = user["user_email"];
  //   final String name = user["user_name"];
  //   final bool absent = user["absent"];

  //   return Column(
  //     children: [
  //       ListTile(
  //         leading:
  //             CircleAvatar(backgroundImage: NetworkImage(photoUrl), radius: 30),
  //         title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Expanded(child: Text(name)),
  //               const VerticalDivider(),
  //               Expanded(child: Text(email)),
  //               const VerticalDivider(),
  //               Expanded(child: Text(absent.toString())),
  //             ]),
  //       ),
  //       const Divider(color: Colors.black)
  //     ],
  //   );
  // }

  // Widget scaffoldBody(BuildContext context) {
  //   return Column(
  //     children: [
  //       ListTile(
  //         leading: const CircleAvatar(
  //             backgroundColor: Colors.transparent, radius: 30),
  //         title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: const <Widget>[
  //               Expanded(
  //                   child: Text(
  //                 "Name",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               )),
  //               VerticalDivider(),
  //               Expanded(
  //                   child: Text("Email",
  //                       style: TextStyle(fontWeight: FontWeight.bold))),
  //               VerticalDivider(),
  //               Expanded(
  //                   child: Text("Absent",
  //                       style: TextStyle(fontWeight: FontWeight.bold))),
  //             ]),
  //       ),
  //       const Divider(color: Colors.black),
  //       Expanded(
  //         child: ListView.builder(
  //           itemCount: users.length,
  //           itemBuilder: (context, index) {
  //             final Map<String, dynamic> currentUser = users[index];

  //             return memberInfo(currentUser);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: scaffoldAppBar(),
    //   body: scaffoldBody(context),
    // );
    final RoomService roomService = RoomService();

    return Scaffold(
      appBar: scaffoldAppBar(),
      body: StreamBuilder<List<User>>(
        stream: roomService.streamUsersAttendance(
            widget.room.id, widget.attendance.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }

          final data = snapshot.data;

          return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final currentData = data[index];

                return ElevatedButton(
                    onPressed: () {}, child: Text(currentData.displayName));
              });
        },
      ),
    );
  }
}
