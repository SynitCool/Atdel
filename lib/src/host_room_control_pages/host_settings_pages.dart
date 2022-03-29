// flutter
import 'package:flutter/material.dart';

// database
import 'package:databases/firebase_firestore.dart';

class HostSettingsPage extends StatefulWidget {
  const HostSettingsPage({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

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
        appBar: scaffoldAppBar(), body: ContentPage(roomId: widget.roomId));
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  Widget disperseRoomButton() {
    final Room room = Room(roomId: widget.roomId);

    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.pop(context);

          room.deleteRoom();

          Navigator.pop(context);
        },
        child: const Text("Disperse Room"));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: disperseRoomButton());
  }
}
