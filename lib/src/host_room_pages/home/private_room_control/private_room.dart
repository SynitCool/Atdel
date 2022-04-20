// flutter
import 'package:flutter/material.dart';

// private room
class PrivateRoom extends StatefulWidget {
  const PrivateRoom({Key? key}) : super(key: key);

  @override
  State<PrivateRoom> createState() => _PrivateRoomState();
}

class _PrivateRoomState extends State<PrivateRoom> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Private Room")));
  }
}
