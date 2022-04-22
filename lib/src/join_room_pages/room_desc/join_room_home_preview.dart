// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/join_room_pages/room_desc/widgets/home_preview.dart';

class JoinRoomPreviewPage extends StatefulWidget {
  const JoinRoomPreviewPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPreviewPage> createState() => _JoinRoomPreviewPageState();
}

class _JoinRoomPreviewPageState extends State<JoinRoomPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ViewHtml());
  }
}
