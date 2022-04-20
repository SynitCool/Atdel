// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class SpecifyHost extends StatefulWidget {
  const SpecifyHost(
      {Key? key, required this.nameRoom, required this.privateRoom})
      : super(key: key);

  final String nameRoom;
  final bool privateRoom;

  @override
  State<SpecifyHost> createState() => _SpecifyHostState();
}

class _SpecifyHostState extends State<SpecifyHost> {
  // widget related
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  @override
  void dispose() {
    nameTextFieldController.dispose();
    super.dispose();
  }

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        backgroundColor: Colors.white38,
        title: const Text("Specify Host"),
        actions: [
          CreateRoomButton(nameRoom: widget.nameRoom, hostAlias: nameText, privateRoom: widget.privateRoom)
        ],
      );

  // error text field
  String? get errorText {
    final String text = nameTextFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  // name room text field widget
  Widget nameTextFieldWidget() => TextField(
        controller: nameTextFieldController,
        decoration: InputDecoration(
            label: const Text("Host alias"),
            border: const OutlineInputBorder(),
            errorText: errorText),
        onChanged: (text) => setState(() {
          nameText = text;
        }),
      );

  // content widget
  Widget contentWidget() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: ListView(
        children: [nameTextFieldWidget()],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: contentWidget(),
    );
  }
}

// create room button
class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton(
      {Key? key, required this.nameRoom, required this.hostAlias, required this.privateRoom})
      : super(key: key);

  final String nameRoom;
  final String hostAlias;
  final bool privateRoom;

  @override
  Widget build(BuildContext context) {
    final RoomService roomService = RoomService();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              if (nameRoom.isEmpty || nameRoom.length < 4) return;
              if (nameRoom.length > 12) return;

              roomService.addRoomToDatabase(nameRoom, hostAlias, privateRoom);

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Create")));
  }
}
