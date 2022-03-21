import 'package:atdel/databases/firebase_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // room button Widget
  Widget roomButtonWidget({
    required String roomTitle,
    required String hostName,
  }) {
    const EdgeInsets cardPadding =
        EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    const EdgeInsets titlePadding = EdgeInsets.fromLTRB(0, 10, 0, 30);
    const IconData icon = Icons.meeting_room;
    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );

    final Widget textRoomTitle = Text(roomTitle);
    final Widget textHostName = Text(hostName);

    return Card(
        margin: cardPadding,
        shape: shape,
        child: ListTile(
          onTap: () {},
          leading: const Icon(icon),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: titlePadding, child: textRoomTitle),
            Align(
              alignment: Alignment.bottomRight,
              child: textHostName,
            )
          ]),
        ));
  }

  // rooms widgets
  Widget roomsWidget(BuildContext context, List<Room> data) {
    Widget contentScene = ListView.builder(
        itemCount: data.length,
        itemBuilder: ((context, index) {
          final Room currentData = data[index];

          final String roomTitle = currentData.info["room_name"];
          final String hostName = currentData.info["host_name"];

          return roomButtonWidget(roomTitle: roomTitle, hostName: hostName);
        }));

    return contentScene;
  }

  // room streaming builder widget
  Widget roomStreamBuilderWidget() {
    const Widget errorScene = Center(child: Text("ERROR"));
    const Widget loadingScene = Center(child: CircularProgressIndicator());

    Stream<List<Room>> readRoom = FirebaseFirestore.instance
        .collection("rooms")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromJson(doc.data())).toList());

    return StreamBuilder<List<Room>>(
      stream: readRoom,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }
        if (snapshot.hasError) return errorScene;

        final rooms = snapshot.data!;

        if (rooms.isEmpty) return const Center(child: Text("No rooms"));

        return roomsWidget(context, rooms);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(user!),
        appBar: appBarWidget(context),
        body: roomStreamBuilderWidget(),
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
  // user profile
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
    // widget parameters
    const Color color = Color.fromRGBO(50, 75, 205, 1);
    const Widget space12 = SizedBox(height: 12);
    const Widget space24 = SizedBox(height: 24);
    const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

    // widget
    final Widget homeButton =
        materialHeaderButton(text: "Home", icon: Icons.home, onClicked: () {});
    final Widget settingButton = materialHeaderButton(
        text: "Setting", icon: Icons.settings, onClicked: () {});

    // content button widgets
    List<Widget> materialDrawerButtons = [
      space12,
      divider70,
      space24,
      homeButton,
      space16,
      settingButton,
      space24,
      divider70,
      space12,
    ];

    // content drawer widgets
    List<Widget> materialDrawerWidget = [
      materialHeader(context, urlImage: urlImage, name: name, email: email),
      Container(
        padding: padding,
        child: Column(
          children: materialDrawerButtons,
        ),
      ),
    ];

    // the background widget
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
