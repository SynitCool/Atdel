// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// states
import 'package:atdel/src/states/selected_attendance.dart';

final selectedAttendance = ChangeNotifierProvider((_) => SelectedAttendance());
