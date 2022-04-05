// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';

class SelectedRoom extends ChangeNotifier {
  Room? room;
  String? typeRoom;

  // setting room
  set setRoom(Room newRoom) {
    room = newRoom;
    notifyListeners();
  }
}
