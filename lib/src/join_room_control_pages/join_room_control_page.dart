// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

// join room feature
import 'package:atdel/src/join_room_control_pages/join_room_home_preview.dart';
import 'package:atdel/src/join_room_control_pages/join_room_drawer.dart';
import 'package:atdel/src/join_room_control_pages/join_room_attendance_list_page.dart';
import 'package:atdel/src/join_room_control_pages/join_room_settings_page.dart';

// database
// import 'package:databases/firebase_firestore.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// page
class JoinRoomControl extends StatefulWidget {
  const JoinRoomControl({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<JoinRoomControl> createState() => _JoinRoomControlState();
}

class _JoinRoomControlState extends State<JoinRoomControl> {
  // the advanced drawer params
  final Color backdropColor = Colors.blueGrey;
  final Curve animationCurve = Curves.easeInOut;
  final Duration animationDuration = const Duration(milliseconds: 300);
  final BoxDecoration childDecoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // widgets bottom navigation bar
  final List<Widget> featurePage = [
  ];
  final List<IconData> iconsPage = [Icons.home, Icons.people];

  int bottomNavIndex = 0;

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  @override
  void initState() {
    super.initState();

    featurePage.add(JoinRoomPreviewPage(
      room: widget.room,
    ));

    featurePage.add(JoinRoomAttendanceList(room: widget.room));
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

    Widget settingsButton = IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const JoinRoomSettings())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );

    return AppBar(
      title: const Text("Join Room Control"),
      leading: leading,
      actions: [settingsButton],
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

  Widget contentRoom() {
    return AdvancedDrawer(
        controller: _advancedDrawerController,
        backdropColor: backdropColor,
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        childDecoration: childDecoration,
        child: mainContentWidget(),
        drawer: DrawerWidget(room: widget.room));
  }

  Widget loadingScene() {
    return Scaffold(
      appBar: appBar(),
      body: const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget errorScene() {
    return Scaffold(
      appBar: appBar(),
      body: const Center(child: Text("Something went wrong!")),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text("Join Room"));
    return contentRoom();
  }
}
