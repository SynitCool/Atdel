// flutter
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
        appBar: scaffoldAppBar(), 
        body: const Center(child: DisperseButton(),));
  }
}

class DisperseButton extends ConsumerWidget {
  const DisperseButton({ Key? key }) : super(key: key);

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