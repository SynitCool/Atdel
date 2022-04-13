// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/main_pages/settings/feature/specify_host.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  // widget related
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  @override
  void dispose() {
    nameTextFieldController.dispose();
    super.dispose();
  }

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

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        backgroundColor: Colors.white38,
        title: const Text("Setting Room"),
        actions: [NextRoomButton(nameRoom: nameText)],
      );

  // name room text field widget
  Widget nameTextFieldWidget() => TextField(
        controller: nameTextFieldController,
        decoration: InputDecoration(
            label: const Text("Room name"),
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

// next room button
class NextRoomButton extends StatelessWidget {
  const NextRoomButton({Key? key, required this.nameRoom}) : super(key: key);

  final String nameRoom;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              if (nameRoom.isEmpty || nameRoom.length < 4) return;
              if (nameRoom.length > 12) return;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpecifyHost(
                            nameRoom: nameRoom,
                          )));
            },
            child: const Text("Next")));
  }
}