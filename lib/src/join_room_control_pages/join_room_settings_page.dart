// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class JoinRoomSettings extends StatefulWidget {
  const JoinRoomSettings({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<JoinRoomSettings> createState() => _JoinRoomSettingsState();
}

class _JoinRoomSettingsState extends State<JoinRoomSettings> {
  PreferredSizeWidget scaffoldAppBar() {
    return AppBar(title: const Text("Join Room Settings"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: scaffoldAppBar(), body: ContentPage(room: widget.room));
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final RoomService _roomService = RoomService();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              
              _roomService.leaveRoom(widget.room);

              Navigator.pop(context);
            },
            child: const Text("Leave Room")));
  }
}
