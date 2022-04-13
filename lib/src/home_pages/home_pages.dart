// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// home pages feature
import 'package:atdel/src/home_pages/create_room_pages.dart';
import 'package:atdel/src/home_pages/join_room_page.dart';
import 'package:atdel/src/home_pages/home_drawer.dart';
import 'package:atdel/src/home_pages/settings_pages.dart';

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
import 'package:atdel/src/providers/selected_room_providers.dart';

// home page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // appbar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        title: const Text("Atdel Demo"),
        elevation: 5,
        actions: const [SettingsButton()],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: appBarWidget(),
        body: const ContentPage(),
        floatingActionButton: const AddRoomButton());
  }
}

// add room button widget
class AddRoomButton extends StatelessWidget {
  const AddRoomButton({Key? key}) : super(key: key);

  final Widget fabOpenIcon = const Icon(Icons.menu, color: Colors.white);
  final Color fabOpenColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
        fabOpenColor: fabOpenColor,
        fabSize: 64.0,
        ringDiameter: 250,
        ringWidth: 70,
        fabOpenIcon: fabOpenIcon,
        children: <Widget>[
          IconButton(
              tooltip: "Create Room",
              icon: const Icon(Icons.create, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateRoomPage()));
              }),
          IconButton(
              tooltip: "Join Room",
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinRoomPage()));
              })
        ]);
  }
}

// content page
class ContentPage extends ConsumerWidget {
  const ContentPage({Key? key}) : super(key: key);

  // scenes
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget noRoomsScene = const Center(child: Text("No Rooms"));

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

                return RoomStreamBuilder(reference: currentReference);
              });
        });
  }
}

// room stream builder
class RoomStreamBuilder extends StatelessWidget {
  const RoomStreamBuilder({Key? key, required this.reference})
      : super(key: key);

  final DocumentReference<Map<String, dynamic>> reference;

  // scenes
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final _roomService = RoomService();
    return StreamBuilder<Room>(
        stream: _roomService.streamReferenceRoom(reference),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return RoomButtonWidget(room: data!);
        });
  }
}

// room button widget
class RoomButtonWidget extends ConsumerWidget {
  const RoomButtonWidget({Key? key, required this.room}) : super(key: key);

  final Room room;

  final EdgeInsets cardPadding =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  final EdgeInsets titlePadding = const EdgeInsets.fromLTRB(0, 10, 0, 30);
  final IconData icon = Icons.meeting_room;

  // text room title
  Widget textRoomTitle() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(room.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          room.roomCode,
          style: const TextStyle(fontSize: 12),
        )
      ]);

  // text host name
  Widget textHostName() => Text(room.hostName);

  // shape of card
  RoundedRectangleBorder shape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentUserProvider = ref.watch(currentUser);
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Card(
        margin: cardPadding,
        shape: shape(),
        child: ListTile(
          onTap: () {
            if (room.hostUid == _currentUserProvider.user!.uid) {
              _selectedRoomProvider.setRoom = room;
              _selectedRoomProvider.setTypeRoom = "host";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HostRoomPages()));
              return;
            }

            _selectedRoomProvider.setRoom = room;
            _selectedRoomProvider.setTypeRoom = "join";

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoinRoomControl()));
            return;
          },
          leading: Icon(icon),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: titlePadding,
                child: FittedBox(child: textRoomTitle())),
            Align(
              alignment: Alignment.bottomRight,
              child: textHostName(),
            ),
          ]),
        ));
  }
}

// settings button
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPages()));
        },
        icon: const Icon(Icons.settings));
  }
}
