import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:atdel/pages/settings_pages.dart';
import 'package:atdel/pages/user_pages.dart';
import 'package:atdel/pages/create_room_pages.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? user;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
  }

  // appbar widget
  PreferredSizeWidget appBarWidget(BuildContext context) {
    Widget appBarSettings = IconButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const SettingsPages())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );

    return AppBar(
      title: const Text("Atdel Demo"),
      actions: [
        appBarSettings,
      ],
      elevation: 5,
    );
  }

  // add room button
  Widget addRoomButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateRoomPage(user!)));
        },
        tooltip: "add room",
        child: const Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(user!),
        appBar: appBarWidget(context),
        body: Center(child: Image.network(user!.photoURL!)),
        floatingActionButton: addRoomButton(context));
  }
}

// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  User user;

  DrawerWidget(this.user, {Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late String name;
  late String email;
  late String urlImage;

  @override
  void initState() {
    super.initState();

    name = widget.user.displayName!;
    email = widget.user.email!;
    urlImage = widget.user.photoURL!;
  }

  // header in drawer type material
  Widget materialHeader(
    BuildContext context, {
    required String urlImage,
    required String name,
    required String email,
  }) {
    const padding = EdgeInsets.symmetric(horizontal: 20);
    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage));
    const SizedBox spaceWidth20 = SizedBox(width: 20);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        name,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      spaceHeight4,
      Text(
        email,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ]);

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserPage(widget.user)));
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

  // button in header type material
  Widget materialHeaderButton(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: const TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  // drawer widget type material
  Widget materialDrawer() {
    const Color color = Color.fromRGBO(50, 75, 205, 1);
    const Widget space12 = SizedBox(height: 12);
    const Widget space24 = SizedBox(height: 24);
    const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

    final Widget homeButton =
        materialHeaderButton(text: "Home", icon: Icons.home, onClicked: () {});
    final Widget settingButton = materialHeaderButton(
        text: "Setting", icon: Icons.settings, onClicked: () {});

    List<Widget> materialDrawerButtons = [
      space12,
      divider70,
      space24,
      homeButton,
      space16,
      settingButton,
      space24,
      divider70,
      space12
    ];

    List<Widget> materialDrawerWidget = [
      materialHeader(context, urlImage: urlImage, name: name, email: email),
      Container(
        padding: padding,
        child: Column(
          children: materialDrawerButtons,
        ),
      )
    ];

    return Material(
        color: color,
        child: ListView(
          children: materialDrawerWidget,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: materialDrawer());
  }
}
