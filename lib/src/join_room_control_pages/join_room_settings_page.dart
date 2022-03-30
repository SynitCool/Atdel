// flutter
import 'package:flutter/material.dart';

// database
import 'package:databases/firebase_firestore.dart';

class JoinRoomSettings extends StatefulWidget {
  const JoinRoomSettings({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

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
        },
        child: const Text("Disperse Room"));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: disperseRoomButton());
  }
}
