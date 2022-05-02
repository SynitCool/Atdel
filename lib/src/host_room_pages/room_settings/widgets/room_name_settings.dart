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

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
    if (roomName.isEmpty) {
      toastWidget("Room Name Supposed Not To Be Empty!");
      return false;
    }
    if (roomName.length < 4) {
      toastWidget("Room Name Length Supposed Not To Be Less Than 4 Characters");
      return false;
    }
    if (roomName.length > 12) {
      toastWidget(
          "Room Name Length Supposed Not To Be Greater Than 12 Characters");
      return false;
    }

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

          SmartDialog.showLoading();

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setRoomName = roomName;

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          SmartDialog.dismiss();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}
