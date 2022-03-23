import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:atdel/src/pages/settings_pages.dart';
import 'package:atdel/src/pages/user_pages.dart';
import 'package:atdel/src/pages/create_room_pages.dart';

import 'package:atdel/src/databases/firebase_firestore.dart' as model;

// home page
// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  model.User userDatabase;

  HomePage(this.userDatabase, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              MaterialPageRoute(builder: (context) => const CreateRoomPage()));
        },
        tooltip: "add room",
        child: const Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(context),
        appBar: appBarWidget(context),
        body: ContentPage(context, widget.userDatabase),
        floatingActionButton: addRoomButton(context));
  }
}

// content page
// ignore: must_be_immutable
class ContentPage extends StatefulWidget {
  BuildContext context;
  model.User userDatabase;

  ContentPage(this.context, this.userDatabase, {Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  // user profile
  late String userUid;

  // stream
  late Stream<List<model.Room>> readRoom;

  // user
  final User? user = FirebaseAuth.instance.currentUser;

  // widgets scene
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();

    debugPrint(widget.userDatabase.toString());

    readRoom = FirebaseFirestore.instance.collection("rooms").snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => model.Room.fromJson(doc.data()))
            .toList());
  }

  // stream local rooms
  Stream<model.Room?> streamLocalRoom() async* {
    final List<dynamic> rooms = widget.userDatabase.rooms;

    if (rooms.isEmpty) yield null;

    for (int i = 0; i < rooms.length; i++) {
      final DocumentReference<Map<String, dynamic>> room = rooms[i];

      final DocumentSnapshot<Map<String, dynamic>> getRoom = await room.get();

      final Map<String, dynamic>? roomJson = getRoom.data();

      final model.Room modelRoom = model.Room.fromJson(roomJson!);

      yield modelRoom;
    }
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
  Widget roomsWidget(BuildContext context, List<dynamic> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: ((context, index) {
          final model.Room currentData = data[index];

          final String roomTitle = currentData.info["room_name"];
          final String hostName = currentData.info["host_name"];

          return roomButtonWidget(roomTitle: roomTitle, hostName: hostName);
        }));
  }

  // builder function
  Widget builderFunction(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingScene;
    }

    if (snapshot.hasError) return errorScene;

    final rooms = snapshot.data;

    if (rooms == null) return const Center(child: Text("No rooms"));

    // if (rooms.isEmpty) return const Center(child: Text("No rooms"));

    // return roomsWidget(context, rooms);

    return loadingScene;
  }

  // build content widget
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: CircularProgressIndicator(),
    // );
    return StreamBuilder<model.Room?>(
      stream: streamLocalRoom(),
      builder: builderFunction,
    );
  }
}

// drawer widget
// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  BuildContext context;

  DrawerWidget(this.context, {Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // user profile
  late String name;
  late String email;
  late String urlImage;

  // user
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    name = user!.displayName!;
    email = user!.email!;
    urlImage = user!.photoURL!;
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserPage(user!)));
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
    // const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

    // widget
    final Widget settingButton = materialHeaderButton(
        text: "Setting",
        icon: Icons.settings,
        onClicked: () {
          Navigator.push(widget.context,
              MaterialPageRoute(builder: (context) => const SettingsPages()));
        });

    // content button widgets
    List<Widget> materialDrawerButtons = [
      space12,
      divider70,
      space24,
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
