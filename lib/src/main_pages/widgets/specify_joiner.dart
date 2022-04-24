// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

class SpecifyJoiner extends StatefulWidget {
  const SpecifyJoiner({Key? key, required this.roomCodeText}) : super(key: key);

  final String roomCodeText;

  @override
  State<SpecifyJoiner> createState() => _SpecifyJoinerState();
}

class _SpecifyJoinerState extends State<SpecifyJoiner> {
  // widget related
  final TextEditingController roomCodeTextFieldController =
      TextEditingController();
  String roomCodeText = '';

  @override
  void dispose() {
    roomCodeTextFieldController.dispose();
    super.dispose();
  }

  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        backgroundColor: Colors.white38,
        title: const Text("Specify User"),
        actions: [
          JoinRoomButton(roomCode: widget.roomCodeText, userAlias: roomCodeText)
        ],
      );

  // error text field
  String? get errorText {
    final String text = roomCodeTextFieldController.value.text;

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
  Widget roomCodeTextFieldWidget() => TextField(
        controller: roomCodeTextFieldController,
        decoration: InputDecoration(
            label: const Text("User alias"),
            border: const OutlineInputBorder(),
            errorText: errorText),
        onChanged: (text) => setState(() {
          roomCodeText = text;
        }),
      );

  // content widget
  Widget contentWidget() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: ListView(
        children: [roomCodeTextFieldWidget()],
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
class JoinRoomButton extends StatelessWidget {
  const JoinRoomButton(
      {Key? key, required this.roomCode, required this.userAlias})
      : super(key: key);

  final String roomCode;
  final String userAlias;

  // show user metric warning
  Future showDialogError(BuildContext context, String desc) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            "ERROR",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final RoomService roomService = RoomService();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () async {
              if (roomCode.isEmpty || roomCode.length != 6) return;
              if (userAlias.isEmpty || userAlias.length > 12) return;

              final String? status =
                  await roomService.joinRoomWithCode(roomCode, userAlias);

              if (status == "code_not_valid") {
                showDialogError(context, "code_not_valid");
              }
              if (status == "code_not_valid") return;
              

              if (status == "room_is_private") {
                showDialogError(context, "room_is_private");
              }
              if (status == "room_is_private") return;

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Text("Join")));
  }
}
