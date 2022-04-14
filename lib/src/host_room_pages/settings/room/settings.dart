// flutter
import 'package:flutter/material.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// set room pages
class SetRoomPages extends ConsumerStatefulWidget {
  const SetRoomPages({Key? key}) : super(key: key);

  @override
  ConsumerState<SetRoomPages> createState() => _SetRoomPagesState();
}

class _SetRoomPagesState extends ConsumerState<SetRoomPages> {
  // room info set
  Map<String, dynamic> newRoomInfo = {};

  // appbar
  PreferredSizeWidget? scaffoldAppBar() => AppBar(
        title: const Text("Update Room"),
        actions: [UpdateRoomButton(newRoominfo: newRoomInfo)],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: scaffoldAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text("Room Info Settings",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              RoomNameSettings(callback: (newRoomName) {
                setState(() {
                  newRoomInfo["room_name"] = newRoomName;
                });
              }),
            ],
          ),
        ));
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
class UpdateRoomButton extends ConsumerWidget {
  const UpdateRoomButton({Key? key, required this.newRoominfo})
      : super(key: key);

  final Map<String, dynamic> newRoominfo;

  // check if valid
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
          if (!newRoomNameValid(newRoominfo["room_name"])) return;

          final oldRoom = Room.copy(selectedRoomProvider.room!);

          selectedRoomProvider.room!.setRoomName = newRoominfo["room_name"];

          roomService.updateRoomInfo(oldRoom, selectedRoomProvider.room!);

          Navigator.pop(context);
        },
        icon: const Icon(Icons.update),
        tooltip: "Update Room",
      ),
    );
  }
}

// room name settings
class RoomNameSettings extends StatefulWidget {
  const RoomNameSettings({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  State<RoomNameSettings> createState() => _RoomNameSettingsState();
}

class _RoomNameSettingsState extends State<RoomNameSettings> {
  // controller
  final TextEditingController newRoomNameController = TextEditingController();
  String newRoomNameText = '';

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
    return Column(
      children: [
        const OldRoomTextField(),
        TextField(
          controller: newRoomNameController,
          decoration: InputDecoration(
              label: const Text("New Room Name"), errorText: errorText),
          onChanged: (text) => setState(() {
            newRoomNameText = text;
            widget.callback(newRoomNameText);
          }),
        ),
      ],
    );
  }
}
