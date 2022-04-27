// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/join_room_pages/room_settings/widgets/room_settings_page.dart';

class JoinRoomSettings extends StatefulWidget {
  const JoinRoomSettings({Key? key}) : super(key: key);

  @override
  State<JoinRoomSettings> createState() => _JoinRoomSettingsState();
}

class _JoinRoomSettingsState extends State<JoinRoomSettings> {
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Join Room Settings"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentPage());
  }
}

// content page
class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          // GeneralTitle(),
          // SetJoinUserRoomButton(),
          // SizedBox(height: 20),
          // MachineLearningRelatedTitle(),
          // SetImageButton(),
          // SizedBox(height: 50),
          DangerZoneTitle(),
          LeaveRoomButton()
        ],
      ),
    );
  }
}
