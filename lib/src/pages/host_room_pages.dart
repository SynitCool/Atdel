import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

// personal packages
import 'package:host_room_control/home_feature.dart';
import 'package:host_room_control/host_drawer.dart';

import 'package:databases/firebase_firestore.dart' as model;

// page
// ignore: must_be_immutable
class HostRoomPages extends StatefulWidget {
  Map<String, dynamic> currentData;

  HostRoomPages(this.currentData, {Key? key}) : super(key: key);

  @override
  State<HostRoomPages> createState() => _HostRoomPagesState();
}

class _HostRoomPagesState extends State<HostRoomPages> {
  // data
  late final List<dynamic> infoUsers;
  late final Map<String, dynamic> infoRoom;
  late final String roomId;

  // the advanced drawer params
  final Color backdropColor = Colors.blueGrey;
  final Curve animationCurve = Curves.easeInOut;
  final Duration animationDuration = const Duration(milliseconds: 300);
  final BoxDecoration childDecoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // widgets bottom navigation bar
  final List<Widget> featurePage = [
    const HomeScreen(),
  ];
  final List<IconData> iconsPage = [Icons.home, Icons.people];

  int bottomNavIndex = 0;

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  @override
  void initState() {
    super.initState();

    infoUsers = widget.currentData["info_users"];
    infoRoom = widget.currentData["info_room"];
    roomId = widget.currentData["id"];

    featurePage.add(AttedanceListScreen(roomId: roomId));
  }

  // the appbar
  PreferredSizeWidget appBar() {
    Widget leading = IconButton(
      onPressed: () {
        _advancedDrawerController.showDrawer();
      },
      icon: ValueListenableBuilder<AdvancedDrawerValue>(
        valueListenable: _advancedDrawerController,
        builder: (_, value, __) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              value.visible ? Icons.clear : Icons.menu,
              key: ValueKey<bool>(value.visible),
            ),
          );
        },
      ),
    );

    return AppBar(title: const Text("Host Room Control"), leading: leading);
  }

  // the screen of feature
  Widget mainContentWidget() {
    return Scaffold(
      appBar: appBar(),
      body: featurePage[bottomNavIndex],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  // bottom navigation bar
  Widget bottomNavigationBar() {
    return AnimatedBottomNavigationBar.builder(
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      splashSpeedInMilliseconds: 300,
      splashColor: Colors.amberAccent,
      elevation: 200,
      itemCount: featurePage.length,
      activeIndex: bottomNavIndex,
      onTap: (int index) {
        setState(() {
          bottomNavIndex = index;
        });
      },
      tabBuilder: (int index, bool isActive) {
        final Color color = isActive ? Colors.amberAccent : Colors.black;

        return Icon(iconsPage[index], color: color);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        controller: _advancedDrawerController,
        backdropColor: backdropColor,
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        childDecoration: childDecoration,
        child: mainContentWidget(),
        drawer: DrawerWidget(usersData: infoUsers));
  }
}

// attendance list screen
class AttedanceListScreen extends StatefulWidget {
  const AttedanceListScreen({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<AttedanceListScreen> createState() => _AttedanceListScreenState();
}

class _AttedanceListScreenState extends State<AttedanceListScreen> {
  // firebase
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  // user profile
  late String userUid;

  // path
  late String readAttendanceListPath;

  // stream
  late Stream<DocumentSnapshot<Map<String, dynamic>>> readAttendanceList;

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // personal database
  late model.AttendanceList _attendanceList;

  @override
  void initState() {
    super.initState();

    // firebase user
    userUid = firebaseUser!.uid;

    // create feature
    _attendanceList =
        model.AttendanceList(roomId: widget.roomId, userUid: userUid);

    // read attendance list
    readAttendanceListPath = "users/$userUid/rooms";

    readAttendanceList = FirebaseFirestore.instance
        .collection(readAttendanceListPath)
        .doc(widget.roomId)
        .snapshots();
  }

  // builder for read attendance list
  Widget builderFunction(BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingScene;
    }

    if (snapshot.hasError) return errorScene;

    final Map<String, dynamic>? roomData = snapshot.data!.data();
    final List<dynamic> attendanceListFeature = roomData!["attendance_list"];

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
      onTap: () {},
      leading: const Icon(icon),
      title: Column(children: [
        Text("Start: " + dateStartAttendanceList),
        Text("End: " + dateEndAttendanceList)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _attendanceList.createFeature(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          return StreamBuilder(stream: readAttendanceList, builder: builderFunction);
        });
  }
}
