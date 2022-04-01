// dart
import 'dart:async';

// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// home pages feature
import 'package:atdel/src/home_pages/settings_pages.dart';
import 'package:atdel/src/home_pages/create_room_pages.dart';
import 'package:atdel/src/home_pages/join_room_page.dart';
import 'package:atdel/src/home_pages/home_drawer.dart';

// host room control
import 'package:atdel/src/host_room_control_pages/host_room_pages.dart';

// join room control
import 'package:atdel/src/join_room_control_pages/join_room_control_page.dart';

// custom widget
import 'package:fab_circular_menu/fab_circular_menu.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/user_services.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart' as src_user;

// home page
// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    // fab parameters
    const Widget fabOpenIcon = Icon(Icons.menu, color: Colors.white);
    const Color fabOpenColor = Colors.white;

    // fab widget button
    Widget iconCreateRoomButton = IconButton(
        tooltip: "Create Room",
        icon: const Icon(Icons.create, color: Colors.white),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateRoomPage()));
        });

    Widget iconJoinRoomButton = IconButton(
        tooltip: "Join Room",
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const JoinRoomPage()));
        });

    return FabCircularMenu(
        fabOpenColor: fabOpenColor,
        fabSize: 64.0,
        ringDiameter: 250,
        ringWidth: 70,
        fabOpenIcon: fabOpenIcon,
        children: <Widget>[iconCreateRoomButton, iconJoinRoomButton]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(context),
        appBar: appBarWidget(context),
        body: ContentPage(context),
        floatingActionButton: addRoomButton(context));
  }
}

// content page
// ignore: must_be_immutable
class ContentPage extends StatefulWidget {
  BuildContext context;

  ContentPage(this.context, {Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  // user profile
  late String userRoomsCollection;
  late String userUid;

  // stream
  late Stream<QuerySnapshot<Map<String, dynamic>>> readRoom;

  // user
  final User? user = FirebaseAuth.instance.currentUser;

  // widgets scene
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();

    userUid = user!.uid;

    userRoomsCollection = "users/$userUid/rooms";

    readRoom =
        FirebaseFirestore.instance.collection(userRoomsCollection).snapshots();
  }

  // room button Widget
  Widget roomButtonWidget(
      BuildContext context, Map<String, dynamic> currentData) {
    // room info
    String typeUser;

    final Map<String, dynamic> infoRoom = currentData["info_room"];

    final String roomTitle = infoRoom["room_name"];
    final String hostName = infoRoom["host_name"];
    final String hostUid = infoRoom["host_uid"];

    // check user type
    if (hostUid != userUid) {
      typeUser = "join";
    } else {
      typeUser = "host";
    }

    // card parameters
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
          onTap: () {
            if (typeUser == "host") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HostRoomPages(currentData: currentData)));
            } else {
              final DocumentReference<Map<String, dynamic>> reference =
                  infoRoom["room_reference"];

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          JoinRoomControl(reference: reference)));
            }
          },
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
          final currentDoc = data[index];
          final Map<String, dynamic> currentData = currentDoc.data();

          return roomButtonWidget(context, currentData);
        }));
  }

  // builder function
  Widget builderFunction(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingScene;
    }

    if (snapshot.hasError) return errorScene;

    final rooms = snapshot.data.docs;

    if (rooms.isEmpty || rooms == null) {
      return const Center(child: Text("No rooms"));
    }

    return roomsWidget(context, rooms);
  }

  // // build content widget
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  //     stream: readRoom,
  //     builder: builderFunction,
  //   );
  // }
  // build content widget
  @override
  Widget build(BuildContext context) {
    final RoomService roomService = RoomService();
    final UserService userService = UserService();

    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    final src_user.User currentUser =
        src_user.User.fromFirebaseAuth(firebaseUser!);

    return StreamBuilder<src_user.User>(
        stream: userService.streamUser(currentUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;
          final references = data!.roomReferences;

          if (references.isEmpty) return const Center(child: Text("No Room"));

          return ListView.builder(
              itemCount: references.length,
              itemBuilder: (context, index) {
                final currentReference = references[index];

                return StreamBuilder<Room>(
                    stream: roomService.streamReferenceRoom(currentReference),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingScene;
                      }

                      if (snapshot.hasError) return errorScene;

                      final data = snapshot.data;

                      return ElevatedButton(
                          onPressed: () {}, child: Text(data!.roomName));
                    });
              });
        });
  }
}
