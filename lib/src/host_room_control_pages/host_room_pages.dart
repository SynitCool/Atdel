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
  // widgets bottom navigation bar
  final List<Widget> featurePage = [];
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

    featurePage.add(AttedanceListScreen(room: widget.room));
  }

  // settings button
  Widget settingsButton() => IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const HostSettingsPage())));
        },
        icon: const Icon(Icons.settings),
        padding: const EdgeInsets.all(15.0),
      );

  // leading animation
  Widget leadingAppBar() => IconButton(
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

  // the appbar
  PreferredSizeWidget appBar() => AppBar(
        title: const Text("Host Room Control"),
        leading: leadingAppBar(),
        actions: [settingsButton()],
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

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        controller: _advancedDrawerController,
        backdropColor: Colors.blueGrey,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: mainContentWidget(),
        drawer: DrawerWidget(room: widget.room));
  }
}
