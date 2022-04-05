// flutter
import 'package:atdel/src/states/current_user.dart';
import 'package:flutter/material.dart';

// firebase
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

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

// home page
class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

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
        drawer: const DrawerWidget(),
        appBar: appBarWidget(context),
        body: const ContentPage(),
        floatingActionButton: addRoomButton(context));
  }
}

// content page
class ContentPage extends ConsumerWidget {
  const ContentPage({Key? key}) : super(key: key);

  // scenes
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget noRoomsScene = const Center(child: Text("No Rooms"));

  // room stream builder
  Widget roomStreamBuilder(DocumentReference<Map<String, dynamic>> reference, CurrentUser currentUser) {
    final _roomService = RoomService();
    return StreamBuilder<Room>(
        stream: _roomService.streamReferenceRoom(reference),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return roomButtonWidget(context, data!, currentUser);
        });
  }

  // room button Widget
  Widget roomButtonWidget(BuildContext context, Room room, CurrentUser currentUser) {
    // card parameters
    const EdgeInsets cardPadding =
        EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    const EdgeInsets titlePadding = EdgeInsets.fromLTRB(0, 10, 0, 30);
    const IconData icon = Icons.meeting_room;
    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );

    // text widget
    final Widget textRoomTitle =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(room.roomName, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(
        room.roomCode,
        style: const TextStyle(fontSize: 12),
      )
    ]);
    final Widget textHostName = Text(room.hostName);

    return Card(
        margin: cardPadding,
        shape: shape,
        child: ListTile(
          onTap: () {
            if (room.hostUid == currentUser.user!.uid) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HostRoomPages(room: room)));
              return;
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JoinRoomControl(room: room)));
          },
          leading: const Icon(icon),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: titlePadding, child: FittedBox(child: textRoomTitle)),
            Align(
              alignment: Alignment.bottomRight,
              child: textHostName,
            ),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(currentUser);
    final _userService = UserService();
    return StreamBuilder<src_user.User>(
        stream: _userService.streamUser(provider.user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;
          final references = data!.roomReferences;

          if (references.isEmpty) return noRoomsScene;

          return ListView.builder(
              itemCount: references.length,
              itemBuilder: (context, index) {
                final currentReference = references[index];

                return roomStreamBuilder(currentReference, provider);
              });
        });
  }
}
