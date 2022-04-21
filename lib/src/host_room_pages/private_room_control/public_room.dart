// flutter
import 'package:flutter/material.dart';

// public room
class PublicRoom extends StatefulWidget {
  const PublicRoom({Key? key}) : super(key: key);

  @override
  State<PublicRoom> createState() => _PublicRoomState();
}

class _PublicRoomState extends State<PublicRoom> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Coming Soon!")));
  }
}