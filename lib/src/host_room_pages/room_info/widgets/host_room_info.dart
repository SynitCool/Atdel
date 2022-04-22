// flutter
import 'package:flutter/material.dart';

// title room info
class TitleRoomInfo extends StatelessWidget {
  const TitleRoomInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Room Info",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26));
  }
}