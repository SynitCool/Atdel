import 'package:flutter/material.dart';
import 'package:atdel/src/app.dart';

import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}
