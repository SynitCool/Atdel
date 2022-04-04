import 'package:flutter/material.dart';
import 'package:atdel/src/app.dart';

import 'package:firebase_core/firebase_core.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: App()));
}
