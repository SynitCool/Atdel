// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  // widget related
  final TextEditingController roomCodeTextFieldController =
      TextEditingController();
  String roomCodeText = '';

  @override
  void dispose() {
    roomCodeTextFieldController.dispose();
    super.dispose();
  }

  // room id error text field
  String? get roomCodeErrorText {
    final String codeRoomText = roomCodeTextFieldController.value.text;

    if (codeRoomText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (codeRoomText.length == 6) return null;

    return 'The room id must be 6 characters';
  }

  // join room button
  Widget joinRoomButton() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
          onPressed: () {
            final RoomService roomService = RoomService();

            roomService.joinRoomWithCode(roomCodeText);

            Navigator.pop(context);
          },
          child: const Text("Join")));

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        backgroundColor: Colors.white38,
        title: const Text("Join room"),
        actions: [joinRoomButton()],
      );

  // name room text field widget
  Widget roomIdFieldWidget() => TextField(
        controller: roomCodeTextFieldController,
        decoration: InputDecoration(
            label: const Text("Room Code"),
            border: const OutlineInputBorder(),
            errorText: roomCodeErrorText),
        onChanged: (text) => setState(() {
          roomCodeText = text;
        }),
      );

  // content widget
  Widget contentWidget() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: ListView(
        children: [roomIdFieldWidget()],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: contentWidget(),
    );
  }
}
