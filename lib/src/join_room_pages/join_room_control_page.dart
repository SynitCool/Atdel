// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

// join room feature
import 'package:atdel/src/join_room_pages/room_desc/join_room_home_preview.dart';
import 'package:atdel/src/join_room_pages/widgets/join_room_drawer.dart';
import 'package:atdel/src/join_room_pages/attendance/join_room_attendance_list_page.dart';
import 'package:atdel/src/join_room_pages/room_info/join_room_info.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// widgets
import 'package:atdel/src/join_room_pages/widgets/join_room_control_page.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_user_room_providers.dart';

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
    const JoinRoomAttendanceList(),
    const RoomInfo()
  ];
  final List<IconData> iconsPage = [Icons.home, Icons.people, Icons.info];

  int bottomNavIndex = 0;

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  // set selected user in user room
  Future setSelectedUserRoom() async {
    // services
    final UserRoomService userRoomService = UserRoomService();

    // providers
    final currentUserProvider = ref.watch(currentUser);
    final selectedRoomProvider = ref.watch(selectedRoom);
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);

    // current user in user room
    final user = await userRoomService.getUserFromUsersRoom(
        selectedRoomProvider.room!, currentUserProvider.user!);

    selectedUserRoomProvider.setUserRoom = user;
  }

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
    setSelectedUserRoom();
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
