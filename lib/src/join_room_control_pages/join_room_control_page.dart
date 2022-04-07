// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

// join room feature
import 'package:atdel/src/join_room_control_pages/join_room_home_preview.dart';
import 'package:atdel/src/join_room_control_pages/join_room_drawer.dart';
import 'package:atdel/src/join_room_control_pages/join_room_attendance_list_page.dart';
import 'package:atdel/src/join_room_control_pages/join_room_settings_page.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// page
class JoinRoomControl extends ConsumerStatefulWidget {
  const JoinRoomControl({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinRoomControl> createState() => _JoinRoomControlState();
}

class _JoinRoomControlState extends ConsumerState<JoinRoomControl> {
  // widgets bottom navigation bar
  final List<Widget> featurePage = [
    const JoinRoomPreviewPage(),
    const JoinRoomAttendanceList()
  ];
  final List<IconData> iconsPage = [Icons.home, Icons.people];

  int bottomNavIndex = 0;

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  // leading appbar
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

  // bottom navigator bar
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

  // the appbar
  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Join Room Control"),
        leading: leadingAppBar(),
        actions: const [SettingsButton()],
      );

  // the screen of feature
  Widget mainContentWidget() => Scaffold(
        appBar: scaffoldAppBar(),
        body: featurePage[bottomNavIndex],
        bottomNavigationBar: bottomNavigationBar(),
      );

  // loading scene
  Widget loadingScene() => Scaffold(
        appBar: scaffoldAppBar(),
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: bottomNavigationBar(),
      );

  // error scene
  Widget errorScene() => Scaffold(
        appBar: scaffoldAppBar(),
        body: const Center(child: Text("Something went wrong!")),
        bottomNavigationBar: bottomNavigationBar(),
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
        drawer: const DrawerWidget());
  }
}

// settings button
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const JoinRoomSettings())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );
  }
}
