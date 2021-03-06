// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// host room feature
import 'package:atdel/src/host_room_pages/room_desc/home_preview_feature.dart';
import 'package:atdel/src/host_room_pages/attendance/attendance_list_pages.dart';
import 'package:atdel/src/host_room_pages/room_info/host_room_info.dart';
import 'package:atdel/src/host_room_pages/members_page/members_page.dart';

// widgets
import 'package:atdel/src/host_room_pages/widgets/host_room_pages.dart';

// page
class HostRoomPages extends StatefulWidget {
  const HostRoomPages({Key? key}) : super(key: key);

  @override
  State<HostRoomPages> createState() => _HostRoomPagesState();
}

class _HostRoomPagesState extends State<HostRoomPages> {
  // widgets bottom navigation bar
  final List<Widget> featurePage = [
    const HomePreviewPage(),
    const AttendanceListPage(),
    const MembersPage(),
    const RoomInfo()
  ];
  final List<IconData> iconsPage = [
    Icons.home,
    Icons.class_,
    Icons.people_alt_outlined,
    Icons.info
  ];

  int bottomNavIndex = 0;

  // the appbar
  PreferredSizeWidget appBar() => AppBar(
        title: const Text("Host Room Control"),
        actions: const [SettingsButton()],
      );

  // the screen of feature
  Widget mainContentWidget() => Scaffold(
        appBar: appBar(),
        body: featurePage[bottomNavIndex],
        bottomNavigationBar: bottomNavigationBar(),
      );

  // bottom navigation bar
  Widget bottomNavigationBar() => AnimatedBottomNavigationBar.builder(
        leftCornerRadius: 32,
        rightCornerRadius: 0,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.defaultEdge,
        splashSpeedInMilliseconds: 300,
        splashColor: Colors.amberAccent,
        elevation: 200,
        itemCount: iconsPage.length,
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

  @override
  Widget build(BuildContext context) {
    return mainContentWidget();
  }
}
