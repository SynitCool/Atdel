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


// old room widget
class OldRoomTextField extends ConsumerWidget {
  const OldRoomTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);

    final oldRoomTextControler =
        TextEditingController(text: selectedRoomProvider.room!.roomName);
    return TextField(
      controller: oldRoomTextControler,
      enabled: false,
      decoration: const InputDecoration(
        label: Text("Old Room Name"),
      ),
    );
  }
}

// update room button
class UpdateRoomNameButton extends ConsumerWidget {
  const UpdateRoomNameButton({Key? key, required this.roomName})
      : super(key: key);

  final String roomName;

  // check room name valid
  bool newRoomNameValid(String roomName) {
    if (roomName.isEmpty) return false;
    if (roomName.length < 4) return false;
    if (roomName.length > 12) return false;

    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final roomService = RoomService();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          if (!newRoomNameValid(roomName)) return;

          if (selectedRoomProvider.room!.roomName == roomName) {
            Navigator.pop(context);
          }
          
          if (selectedRoomProvider.room!.roomName == roomName) return;

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setRoomName = roomName;

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          Navigator.pop(context);
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}
