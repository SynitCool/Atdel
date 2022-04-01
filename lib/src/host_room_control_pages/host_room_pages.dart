// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

// host room feature
import 'package:atdel/src/host_room_control_pages/home_preview_feature.dart';
import 'package:atdel/src/host_room_control_pages/host_drawer.dart';
import 'package:atdel/src/host_room_control_pages/attendance_list_pages.dart';
import 'package:atdel/src/host_room_control_pages/host_settings_pages.dart';

// model
import 'package:atdel/src/model/room.dart';

// page
class HostRoomPages extends StatefulWidget {
  const HostRoomPages({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<HostRoomPages> createState() => _HostRoomPagesState();
}

class _HostRoomPagesState extends State<HostRoomPages> {
  // the advanced drawer params
  final Color backdropColor = Colors.blueGrey;
  final Curve animationCurve = Curves.easeInOut;
  final Duration animationDuration = const Duration(milliseconds: 300);
  final BoxDecoration childDecoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // widgets bottom navigation bar
  final List<Widget> featurePage = [
    // const Center(child: Text("Home Screen")),
    const Center(child: Text("Attendance List"))
  ];
  final List<IconData> iconsPage = [Icons.home, Icons.people];

  int bottomNavIndex = 0;

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  @override
  void initState() {
    super.initState();

    featurePage.add(HomePreviewPage(
      room: widget.room,
    ));

    // featurePage.add(AttedanceListScreen(roomId: widget.currentData["id"]));
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

    // Widget settingsButton = IconButton(
    //   onPressed: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: ((context) =>
    //                 HostSettingsPage(roomId: widget.currentData["id"]))));
    //   },
    //   icon: const Icon(Icons.settings),
    //   padding: const EdgeInsets.all(15.0),
    // );

    return AppBar(
      title: const Text("Host Room Control"),
      leading: leading,
      // actions: [settingsButton],
    );
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
  }

  Widget contentHostRoom() {
    return AdvancedDrawer(
        controller: _advancedDrawerController,
        backdropColor: backdropColor,
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        childDecoration: childDecoration,
        child: mainContentWidget(),
        drawer: DrawerWidget(room: widget.room));
  }

  @override
  Widget build(BuildContext context) {
    return contentHostRoom();
  }
}
