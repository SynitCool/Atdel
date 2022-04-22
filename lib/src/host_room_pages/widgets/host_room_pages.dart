// flutter
import 'package:flutter/material.dart';

// host room feature
import 'package:atdel/src/host_room_pages/room_settings/host_settings_pages.dart';


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
                builder: ((context) => const HostSettingsPage())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );
  }
}
