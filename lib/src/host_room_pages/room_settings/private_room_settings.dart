// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/private_room_settings.dart';

// private room settings
class PrivateRoomSettingsPage extends StatefulWidget {
  const PrivateRoomSettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivateRoomSettingsPage> createState() =>
      _PrivateRoomSettingsPageState();
}

class _PrivateRoomSettingsPageState extends State<PrivateRoomSettingsPage> {
  bool privateRoomValue = false;

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [UpdatePrivateRoomButton(privateRoom: privateRoomValue)],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const OldPrivateRoomSetting(),
            const SizedBox(height: 10),
            CheckboxListTile(
                shape: const OutlineInputBorder(),
                value: privateRoomValue,
                title: const Text("New Private Room Settings"),
                subtitle:
                    const Text("The host can specify who can enter the room"),
                onChanged: (value) => setState(() {
                      privateRoomValue = value!;
                    }))
          ],
        ),
      ),
    );
  }
}