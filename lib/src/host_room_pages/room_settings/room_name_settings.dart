// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/room_name_settings.dart';

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