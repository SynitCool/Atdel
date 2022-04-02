// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// personal packages
import 'package:databases/firebase_firestore.dart' as model;

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
  // firebase
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  // user profile
  late String userUid;

  // path
  late String readAttendanceListPath;

  // stream
  late Stream<DocumentSnapshot<Map<String, dynamic>>> readAttendanceList;

  // floating action button animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // personal database
  late model.AttendanceList _attendanceList;

  @override
  void initState() {
    super.initState();

    // firebase user
    // userUid = firebaseUser!.uid;

    // // create attendance object
    // _attendanceList =
    //     model.AttendanceList(roomId: widget.roomId, userUid: userUid);

    // // read attendance list
    // readAttendanceListPath = "users/$userUid/rooms";

    // readAttendanceList = FirebaseFirestore.instance
    //     .collection(readAttendanceListPath)
    //     .doc(widget.roomId)
    //     .snapshots();

    // floating action button animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  // builder for read attendance list
  // Widget builderFunction(BuildContext context,
  //     AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return loadingScene;
  //   }

  //   if (snapshot.hasError) return errorScene;

  //   final Map<String, dynamic>? roomData = snapshot.data!.data();

  //   if (roomData == null) return errorScene;

  //   final List<dynamic> attendanceListFeature = roomData["attendance_list"];

  //   if (attendanceListFeature.isEmpty) {
  //     return const Center(child: Text("No attendance"));
  //   }

  //   return attendanceWidget(context, attendanceListFeature);
  // }

  // // attendance widget
  // Widget attendanceWidget(BuildContext context, List<dynamic> data) {
  //   return ListView.builder(
  //       itemCount: data.length,
  //       itemBuilder: ((context, index) {
  //         final currentDoc = data[index];
  //         final Map<String, dynamic> currentData = currentDoc.data();

  //         return attendanceListButtonWidget(context, currentData);
  //       }));
  // }

  // // attendance list button widget
  // Widget attendanceListButtonWidget(
  //     BuildContext context, Map<String, dynamic> currentData) {
  //   // attendance list info
  //   final String dateStartAttendanceList =
  //       currentData["date_start"].toDate().toString();

  //   final String dateEndAttendanceList =
  //       currentData["date_end"].toDate().toString();

  //   // widgets parameters
  //   const IconData icon = Icons.date_range;

  //   return ListTile(
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   MembersAttendanceListPage(attendanceInfo: currentData)));
  //     },
  //     leading: const Icon(icon),
  //     title: Column(children: [
  //       Text("Start: " + dateStartAttendanceList),
  //       Text("End: " + dateEndAttendanceList)
  //     ]),
  //   );
  // }

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
    // return Scaffold(
    //     floatingActionButton: floatingActionButtonWidget(),
    //     body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //         stream: FirebaseFirestore.instance
    //             .collection(
    //                 "users/$userUid/rooms/${widget.roomId}/attendance_list")
    //             .snapshots(),
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return loadingScene;
    //           }

    //           if (snapshot.hasError) return errorScene;

    //           final attendanceList = snapshot.data!.docs;

    //           if (attendanceList.isEmpty) {
    //             return const Center(child: Text("No Attendance"));
    //           }

    //           return attendanceWidget(context, attendanceList);
    //         }));

    final RoomService roomService = RoomService();

    return Scaffold(
        floatingActionButton: floatingActionButtonWidget(),
        body: StreamBuilder<List<Attendance>>(
          stream: roomService.streamAttendanceList(widget.room.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingScene;
            }

            if (snapshot.hasError) return errorScene;

            final data = snapshot.data;

            if (data!.isEmpty) return const Center(child: Text("No attendance"));

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final currentData = data[index];

                  return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => 
                            MembersAttendanceListPage(room: widget.room, attendance: currentData)));
                      },
                      child: Text(currentData.dateStart.toString()));
                });
          },
        ));
  }
}
