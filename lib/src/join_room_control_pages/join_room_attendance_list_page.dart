// flutter
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


// pages
import 'package:atdel/src/host_room_control_pages/members_attendance_list_pages.dart';

class JoinRoomAttendanceList extends StatefulWidget {
  const JoinRoomAttendanceList({Key? key, required this.reference})
      : super(key: key);

  final DocumentReference<Map<String, dynamic>> reference;

  @override
  State<JoinRoomAttendanceList> createState() => _JoinRoomAttendanceListState();
}

class _JoinRoomAttendanceListState extends State<JoinRoomAttendanceList> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // builder for read attendance list
  Widget builderFunction(BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>?>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingScene;
    }

    if (snapshot.hasError) return errorScene;

    final Map<String, dynamic>? roomData = snapshot.data!.data();

    if (roomData == null) return errorScene;

    final List<dynamic> attendanceListFeature = roomData["attendance_list"];

    if (attendanceListFeature.isEmpty) {
      return const Center(child: Text("No attendance"));
    }

    return attendanceWidget(context, attendanceListFeature);
  }

  // attendance widget
  Widget attendanceWidget(BuildContext context, List<dynamic> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: ((context, index) {
          final Map<String, dynamic> currentData = data[index];

          return attendanceListButtonWidget(context, currentData);
        }));
  }

  // attendance list button widget
  Widget attendanceListButtonWidget(
      BuildContext context, Map<String, dynamic> currentData) {
    // attendance list info
    final String dateStartAttendanceList =
        currentData["date_start"].toDate().toString();

    final String dateEndAttendanceList =
        currentData["date_end"].toDate().toString();

    // widgets parameters
    const IconData icon = Icons.date_range;

    return ListTile(
      onTap: () {
      },
      leading: const Icon(icon),
      title: Column(children: [
        Text("Start: " + dateStartAttendanceList),
        Text("End: " + dateEndAttendanceList)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>?>>(
            stream: widget.reference.snapshots(), 
            builder: builderFunction));
  }
}
