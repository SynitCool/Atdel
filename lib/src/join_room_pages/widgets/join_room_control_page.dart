// flutter
import 'package:flutter/material.dart';

// join room feature
import 'package:atdel/src/join_room_pages/room_settings/join_room_settings_page.dart';


// settings button
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const JoinRoomSettings())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );
  }
}
