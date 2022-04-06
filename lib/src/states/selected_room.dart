// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';

class SelectedRoom extends ChangeNotifier {
  Room? room;
  String? typeRoom;

  // set room
  set setRoom(Room newRoom) {
    room = newRoom;
    notifyListeners();
  }

  // set type room
  set setTypeRoom(String newTypeRoom) {
    typeRoom = newTypeRoom;
    notifyListeners();
  }
}
