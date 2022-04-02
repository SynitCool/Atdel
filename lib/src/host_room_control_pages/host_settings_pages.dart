// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class HostSettingsPage extends StatefulWidget {
  const HostSettingsPage({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<HostSettingsPage> createState() => _HostSettingsPageState();
}

class _HostSettingsPageState extends State<HostSettingsPage> {
  PreferredSizeWidget scaffoldAppBar() {
    return AppBar(title: const Text("Host Room Settings"));
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

  Widget disperseRoomButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.pop(context);

          _roomService.deleteRoomFromDatabase(widget.room);

          Navigator.pop(context);
        },
        child: const Text("Disperse Room"));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: disperseRoomButton());
  }
}
