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

// room name option page
class RoomNameOptionPage extends StatefulWidget {
  const RoomNameOptionPage({Key? key}) : super(key: key);

  @override
  State<RoomNameOptionPage> createState() => _RoomNameOptionPageState();
}

class _RoomNameOptionPageState extends State<RoomNameOptionPage> {
  // controller
  final TextEditingController newRoomNameController = TextEditingController();
  String newRoomNameText = '';

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [UpdateRoomNameButton(roomName: newRoomNameText)],
      );

  @override
  void dispose() {
    newRoomNameController.dispose();
    super.dispose();
  }

  // error text field
  String? get errorText {
    final String text = newRoomNameController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const OldRoomTextField(),
            TextField(
              controller: newRoomNameController,
              decoration: InputDecoration(
                  label: const Text("New Room Name"), errorText: errorText),
              onChanged: (text) => setState(() {
                newRoomNameText = text;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

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
