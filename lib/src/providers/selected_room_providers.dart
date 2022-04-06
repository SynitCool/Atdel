// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// model
import 'package:atdel/src/states/selected_room.dart';

final selectedRoom = ChangeNotifierProvider((_) => SelectedRoom());
