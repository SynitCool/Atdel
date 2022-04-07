// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// states
import 'package:atdel/src/states/current_user.dart';

final currentUser = ChangeNotifierProvider((_) => CurrentUser());
