// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/user_room.dart';

class SelectedUserRoom extends ChangeNotifier {
  UserRoom? userRoom;

  // set user room
  set setUserRoom(UserRoom newUserRoom) {
    userRoom = newUserRoom;
    notifyListeners();
  }
}
