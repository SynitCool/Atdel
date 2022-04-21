// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/main_pages/widgets/specify_host.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  // name text controller
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  // private room
  bool privateRoom = false;

  // attendance with ml
  bool attendanceWithMl = false;

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
        actions: [
          NextRoomButton(
            nameRoom: nameText,
            privateRoom: privateRoom,
            attendanceWithMl: attendanceWithMl,
          )
        ],
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
        children: [
          nameTextFieldWidget(),
          const SizedBox(height: 30),
          privateRoomCheckBox(),
          const SizedBox(height: 10),
          attendanceWithMlCheckBox()
        ],
      ));

  // private room checkbox
  Widget privateRoomCheckBox() => CheckboxListTile(
      shape: const OutlineInputBorder(),
      value: privateRoom,
      title: const Text("Make as Private"),
      subtitle: const Text("The host can specify who can enter the room"),
      onChanged: (value) {
        setState(() {
          privateRoom = value!;
        });
      });

  // private room checkbox
  Widget attendanceWithMlCheckBox() => CheckboxListTile(
      shape: const OutlineInputBorder(),
      value: attendanceWithMl,
      title: const Text("Attendance With ML"),
      subtitle: const Text("Take attendance with machine learning."),
      onChanged: (value) {
        setState(() {
          attendanceWithMl = value!;
        });
      });

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
  const NextRoomButton(
      {Key? key,
      required this.nameRoom,
      required this.privateRoom,
      required this.attendanceWithMl})
      : super(key: key);

  final String nameRoom;
  final bool privateRoom;
  final bool attendanceWithMl;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              if (nameRoom.isEmpty || nameRoom.length < 4) return;
              if (nameRoom.length > 12) return;

              final Map<String, dynamic> roomInfoMap = {
                "room_name": nameRoom,
                "private_room": privateRoom,
                "attendance_with_ml": attendanceWithMl
              };

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpecifyHost(
                          roomInfo: roomInfoMap)));
            },
            child: const Text("Next")));
  }
}
