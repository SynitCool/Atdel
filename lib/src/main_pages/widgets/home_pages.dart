// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// host room control
import 'package:atdel/src/host_room_pages/host_room_pages.dart';

// join room control
import 'package:atdel/src/join_room_pages/join_room_control_page.dart';

// custom widget
import 'package:fab_circular_menu/fab_circular_menu.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/user_room_services.dart';

// model
import 'package:atdel/src/model/room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_user_room_providers.dart';

// pages
import 'package:atdel/src/main_pages/create_room/create_room_page.dart';
import 'package:atdel/src/main_pages/join_room/join_room_page.dart';
import 'package:atdel/src/main_pages/home_settings/settings_pages.dart';

// skeleton
import 'package:skeleton_text/skeleton_text.dart';

// option room button widget
class OptionRoomButton extends StatelessWidget {
  const OptionRoomButton({Key? key}) : super(key: key);

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
            return const RoomButtonSkeleton();
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return RoomButtonWidget(room: data!);
        });
  }
}

// room button skeleton
class RoomButtonSkeleton extends StatelessWidget {
  const RoomButtonSkeleton({Key? key}) : super(key: key);

  final EdgeInsets cardPadding =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  final EdgeInsets titlePadding = const EdgeInsets.fromLTRB(0, 10, 0, 30);

  // shape of card
  RoundedRectangleBorder shape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: cardPadding,
      shape: shape(),
      child: ListTile(
        onTap: () async {},
        leading: SkeletonAnimation(
            child: CircleAvatar(
          child: Container(height: 100, width: 100, color: Colors.grey),
          radius: 30,
        )),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: titlePadding,
              child: FittedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAnimation(
                      child: Container(
                          height: 15,
                          width: MediaQuery.of(context).size.width * 0.6,
                          color: Colors.grey)),
                  const SizedBox(height: 10),
                  SkeletonAnimation(
                      child: Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.grey))
                ],
              ))),
          Align(
            alignment: Alignment.bottomRight,
            child: SkeletonAnimation(
                child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.grey)),
          ),
        ]),
      ),
    );
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
    // provider
    final _currentUserProvider = ref.watch(currentUser);
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedUserRoomProvider = ref.watch(selectedUserRoom);

    // services
    final UserRoomService userRoomService = UserRoomService();

    return Card(
        elevation: 15,
        margin: cardPadding,
        shape: shape(),
        child: ListTile(
          onTap: () async {
            final user = await userRoomService.getUserFromUsersRoom(
                room, _currentUserProvider.user!);

            _selectedUserRoomProvider.setUserRoom = user;
            _selectedRoomProvider.setRoom = room;

            if (room.hostUid == _currentUserProvider.user!.uid) {
              _selectedRoomProvider.setTypeRoom = "host";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HostRoomPages()));
              return;
            }

            _selectedRoomProvider.setTypeRoom = "join";

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoinRoomControl()));
            return;
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(room.hostPhotoUrl), radius: 30),
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
        icon: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(
              Icons.settings,
              size: 20,
            )));
  }
}

// custom app bar
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.28,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 50, left: 23, right: 23, bottom: 23),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                    text: "Atdel",
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPages()));
                    },
                    icon: const Icon(Icons.settings, color: Colors.white)),
              ],
            ),
            Row(
              children: const [
                TextWidget(
                    text: "An amazing app to take attendance.",
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// text widget for custom app bar
class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TextWidget(
      {Key? key,
      required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ));
  }
}
