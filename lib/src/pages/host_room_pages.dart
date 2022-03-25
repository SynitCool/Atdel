import 'package:atdel/src/pages/user_pages.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// custom widget
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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

  // the advanced drawer params
  final Color backdropColor = Colors.blueGrey;
  final Curve animationCurve = Curves.easeInOut;
  final Duration animationDuration = const Duration(milliseconds: 300);
  final BoxDecoration childDecoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // controller
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  @override
  void initState() {
    super.initState();

    infoUsers = widget.currentData["info_users"];
    infoRoom = widget.currentData["info_room"];
  }

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

  Widget mainContentWidget() {
    return Scaffold(appBar: appBar());
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
        drawer: DrawerWidget(infoUsers));
  }
}

// drawer
// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  List<dynamic> usersData;

  DrawerWidget(this.usersData, {Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // drawer host room
  Widget materialHeader(BuildContext context, Map<String, dynamic> hostInfo) {
    // host profile
    final String urlImage = hostInfo["user_image_url"];
    final String name = hostInfo["user_name"];
    final String email = hostInfo["user_email"];

    const padding = EdgeInsets.symmetric(horizontal: 20);
    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage));
    const SizedBox spaceWidth20 = SizedBox(width: 20);
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.home,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            name,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        email,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ]);

    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              avatarPicture,
              spaceWidth20,
              avatarInfoWidget,
            ],
          )),
    );
  }

  // drawer member room
  Widget materialContentButton(
      BuildContext context, Map<String, dynamic> memberInfo) {
    // host profile
    final String urlImage = memberInfo["user_image_url"];
    final String name = memberInfo["user_name"];
    final String email = memberInfo["user_email"];

    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage));
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            name,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        email,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ]);

    return ListTile(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      leading: avatarPicture,
      title: avatarInfoWidget,
    );
  }

  // drawer content
  Widget materialDrawer() {
    // widget parameters
    const Widget space12 = SizedBox(height: 12);
    const Widget space24 = SizedBox(height: 24);
    // const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);
    const Widget memberTitle = Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Members",
        style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );

    // user type
    late Map<String, dynamic> hostUser;
    List<dynamic> membersUser = [];

    // separate member and host
    for (int i = 0; i < widget.usersData.length; i++) {
      Map<String, dynamic> currentUser = widget.usersData[i];
      String userType = currentUser["type"];

      if (userType == "Host") {
        hostUser = currentUser;
      } else {
        membersUser.add(currentUser);
      }
    }

    // content button widgets
    List<Widget> materialDrawerButtons = [
      space12,
      divider70,
      memberTitle,
      space24,
    ];

    // adding member button
    for (int i = 0; i < membersUser.length; i++) {
      Map<String, dynamic> currentMember = membersUser[i];

      materialDrawerButtons.add(materialContentButton(context, currentMember));
    }

    // content drawer widgets
    List<Widget> materialDrawerWidget = [
      materialHeader(context, hostUser),
      Container(
        padding: padding,
        child: Column(
          children: materialDrawerButtons,
        ),
      ),
    ];

    // the background widget
    return ListView(
      children: materialDrawerWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return materialDrawer();
  }
}

// floating action button
class FloatingActionButtonWidget extends StatefulWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  State<FloatingActionButtonWidget> createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(children: []);
  }
}

// bottom navigation bar
class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarWidget();
  }
}
