import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:atdel/databases/firebase_firestore.dart' as model;

// ignore: must_be_immutable
class CreateRoomPage extends StatefulWidget {
  User user;

  CreateRoomPage(this.user, {Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
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

  // create room
  Future createRoom(BuildContext context) async {
    if (nameText.isEmpty) return;
    if (nameText.length < 4) return;

    final String roomName = nameText;
    final String? hostName = widget.user.displayName;
    final String? hostEmail = widget.user.email;
    final String? hostUid = widget.user.uid;
    final String? hostImageUrl = widget.user.photoURL;
    const int memberCounts = 1;

    final Map<String, dynamic> info = {
      "room_name": roomName,
      "host_name": hostName,
      "host_email": hostEmail,
      "host_uid": hostUid,
      "host_image_url": hostImageUrl,
      "member_counts": memberCounts
    };

    final List<Map<String, dynamic>> users = [
      {
        "user_name": hostName,
        "user_email": hostEmail,
        "user_uid": hostUid,
        "user_image_url": hostImageUrl,
        "type": "Host"
      }
    ];

    final model.Room room = model.Room(info: info, users: users);

    Navigator.pop(context);

    await room.createRoom();
  }

  // app bar widget
  PreferredSizeWidget appBarWidget(BuildContext context) {
    final Widget createRoomButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              createRoom(context);
            },
            child: const Text("Create")));

    return AppBar(
      backgroundColor: Colors.white38,
      title: const Text("Create room"),
      actions: [createRoomButton],
    );
  }

  // name room text field widget
  Widget nameTextFieldWidget() {
    return TextField(
      controller: nameTextFieldController,
      decoration: InputDecoration(
          label: const Text("Room name"),
          border: const OutlineInputBorder(),
          errorText: errorText),
      onChanged: (text) => setState(() {
        nameText = text;
      }),
    );
  }

  // content widget
  Widget contentWidget() {
    const EdgeInsets padding =
        EdgeInsets.symmetric(horizontal: 30, vertical: 30);

    return Padding(
        padding: padding,
        child: ListView(
          children: [nameTextFieldWidget()],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: contentWidget(),
    );
  }
}
