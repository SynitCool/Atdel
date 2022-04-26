// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/private_room.dart';

// private room
class PrivateRoom extends StatefulWidget {
  const PrivateRoom({Key? key}) : super(key: key);

  @override
  State<PrivateRoom> createState() => _PrivateRoomState();
}

class _PrivateRoomState extends State<PrivateRoom> {
  PreferredSizeWidget? scaffoldAppBar() =>
      AppBar(title: const Text("Set Selected Users"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const PrivateContentRoom());
  }
}

// private content room
class PrivateContentRoom extends StatefulWidget {
  const PrivateContentRoom({Key? key}) : super(key: key);

  @override
  State<PrivateContentRoom> createState() => _PrivateContentRoomState();
}

class _PrivateContentRoomState extends State<PrivateContentRoom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          ShowSelectedUsersButton(),
          AddSelectedUsersButton(),
        ],
      ),
    );
  }
}
