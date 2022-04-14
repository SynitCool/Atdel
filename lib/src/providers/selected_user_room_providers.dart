// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// state
import 'package:atdel/src/states/selected_user_room.dart';


final selectedUserRoom = ChangeNotifierProvider((_) => SelectedUserRoom());