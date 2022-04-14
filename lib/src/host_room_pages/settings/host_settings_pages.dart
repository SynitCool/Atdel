// flutter
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// pages
import 'package:atdel/src/host_room_pages/settings/room/settings.dart';

// settings page
class HostSettingsPage extends StatefulWidget {
  const HostSettingsPage({Key? key}) : super(key: key);

  @override
  State<HostSettingsPage> createState() => _HostSettingsPageState();
}

class _HostSettingsPageState extends State<HostSettingsPage> {
  // scaffold app bar
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Host Room Settings"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentSettings());
  }
}

// content settings
class ContentSettings extends StatelessWidget {
  const ContentSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text("General", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          SettingsRoomButton(),
          SizedBox(
            height: 30,
          ),
          Text(
            "DANGER ZONE",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          DisperseButton(),
        ],
      ),
    );
  }
}

// disperse button
class DisperseButton extends ConsumerWidget {
  const DisperseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _roomService = RoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.pop(context);

          _roomService.deleteRoomFromDatabase(_selectedRoomProvider.room!);

          Navigator.pop(context);
        },
        child: const Text("Disperse Room"));
  }
}

// settings room button
class SettingsRoomButton extends StatelessWidget {
  const SettingsRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.room_preferences),
      title: const Text("Set Room"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SetRoomPages()));
      },
    );
  }
}
