import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  // widget related
  final TextEditingController userTextFieldController = TextEditingController();
  final TextEditingController roomIdTextFieldController =
      TextEditingController();
  String userUidText = '';
  String roomIdText = '';

  @override
  void dispose() {
    userTextFieldController.dispose();
    roomIdTextFieldController.dispose();
    super.dispose();
  }

  // user error text field
  String? get userErrorText {
    final String userText = userTextFieldController.value.text;

    if (userText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (userText.length < 16) {
      return 'The user uid must be greater than 16';
    }

    return null;
  }

  // room id error text field
  String? get roomIdErrorText {
    final String idRoomText = roomIdTextFieldController.value.text;

    if (idRoomText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (idRoomText.length < 16) {
      return 'The room id must be greater than 16';
    }

    return null;
  }

  // join room
  Future joinRoom(BuildContext context) async {
    // firebase user
    final User? user = FirebaseAuth.instance.currentUser;
    final String userUid = user!.uid;

    // creator room
    final String collectionCreatorRoomString = "users/$userUidText/rooms";

    final CollectionReference<Map<String, dynamic>> collectionCreatorRoom =
        FirebaseFirestore.instance.collection(collectionCreatorRoomString);

    final DocumentReference<Map<String, dynamic>> docCreatorRoom =
        collectionCreatorRoom.doc(roomIdText);

    final DocumentSnapshot<Map<String, dynamic>> getCreatorRoom =
        await docCreatorRoom.get();
    final Map<String, dynamic>? dataCreatorRoom = getCreatorRoom.data();
    final Map<String, dynamic> infoCreatorRoom = dataCreatorRoom!["info_room"];

    // joiner room
    final String collectionJoinerRoomString = "users/$userUid/rooms";

    final CollectionReference<Map<String, dynamic>> collectionJoinerRoom =
        FirebaseFirestore.instance.collection(collectionJoinerRoomString);

    final DocumentReference<Map<String, dynamic>> docJoinerRoom =
        collectionJoinerRoom.doc(roomIdText);

    final Map<String, dynamic> infoJoinerroom = infoCreatorRoom;

    infoJoinerroom["room_reference"] = docCreatorRoom;

    final Map<String, dynamic> wrapperInfoJoinerroom = {
      "info_room": infoJoinerroom
    };

    await docJoinerRoom.set(wrapperInfoJoinerroom);

    // back to home
    Navigator.pop(context);
  }

  // app bar widget
  PreferredSizeWidget appBarWidget(BuildContext context) {
    final Widget joinRoomButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
            onPressed: () {
              joinRoom(context);
            },
            child: const Text("Join")));

    return AppBar(
      backgroundColor: Colors.white38,
      title: const Text("Join room"),
      actions: [joinRoomButton],
    );
  }

  // name room text field widget
  Widget userTextFieldWidget() {
    return TextField(
      controller: userTextFieldController,
      decoration: InputDecoration(
          label: const Text("User UID"),
          border: const OutlineInputBorder(),
          errorText: userErrorText),
      onChanged: (text) => setState(() {
        userUidText = text;
      }),
    );
  }

  // name room text field widget
  Widget roomIdFieldWidget() {
    return TextField(
      controller: roomIdTextFieldController,
      decoration: InputDecoration(
          label: const Text("Room ID"),
          border: const OutlineInputBorder(),
          errorText: roomIdErrorText),
      onChanged: (text) => setState(() {
        roomIdText = text;
      }),
    );
  }

  // content widget
  Widget contentWidget() {
    const EdgeInsets padding =
        EdgeInsets.symmetric(horizontal: 30, vertical: 30);

    const SizedBox space20 = SizedBox(height: 20);

    return Padding(
        padding: padding,
        child: ListView(
          children: [userTextFieldWidget(), space20, roomIdFieldWidget()],
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
