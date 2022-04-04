// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// model
import 'package:atdel/src/model/selected_room.dart';

final selectedProvider = ChangeNotifierProvider((_) => SelectedRoom());
