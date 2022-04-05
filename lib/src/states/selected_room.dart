// flutter
import 'package:flutter/material.dart';


class SelectedRoom extends ChangeNotifier {
  int room = 0;

  void increament() {
    room++;
    notifyListeners();
  }
}
