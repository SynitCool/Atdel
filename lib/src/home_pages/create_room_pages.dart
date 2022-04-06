// flutter
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  // user related
  final User? user = FirebaseAuth.instance.currentUser;

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
    }
    if (text.length < 4) {
      return 'Too short';
    }

    return null;
  }

  // create room button
  Widget createRoomButton() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
          onPressed: () {
            final RoomService roomService = RoomService();

            roomService.addRoomToDatabase(nameText);

            Navigator.pop(context);
          },
          child: const Text("Create")));

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
      backgroundColor: Colors.white38,
      title: const Text("Create room"),
      actions: [createRoomButton()],
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
