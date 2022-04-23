// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// model
import 'package:atdel/src/model/room.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// old private room settings
class OldPrivateRoomSetting extends ConsumerWidget {
  const OldPrivateRoomSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final privateRoomValue = selectedRoomProvider.room!.privateRoom;
    return CheckboxListTile(
        shape: const OutlineInputBorder(),
        value: privateRoomValue,
        title: const Text("Old Private Room Settings"),
        subtitle: const Text("The host can specify who can enter the room"),
        onChanged: (value) {});
  }
}

// update room button
class UpdatePrivateRoomButton extends ConsumerWidget {
  const UpdatePrivateRoomButton({Key? key, required this.privateRoom})
      : super(key: key);

  final bool privateRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final roomService = RoomService();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          if (selectedRoomProvider.room!.privateRoom == privateRoom) {
            Navigator.pop(context);
          }

          if (selectedRoomProvider.room!.privateRoom == privateRoom) return;

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setPrivateRoom = privateRoom;

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}
