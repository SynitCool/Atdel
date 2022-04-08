// flutter
import 'package:atdel/src/home_pages/specify_joiner.dart';
import 'package:flutter/material.dart';


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

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        backgroundColor: Colors.white38,
        title: const Text("Join room"),
        actions: [NextRoomButton(roomCode: roomCodeText,)],
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

class NextRoomButton extends StatelessWidget {
  const NextRoomButton({Key? key, required this.roomCode}) : super(key: key);

  final String roomCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              if (roomCode.isEmpty || roomCode.length != 6) return;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpecifyJoiner(roomCodeText: roomCode)));
            },
            child: const Text("Next")));
  }
}
