import 'package:flutter/material.dart';

import 'package:atdel/pages/permission_pages.dart';
import 'package:atdel/authentication/firebase_authentication.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(), 
      child: const MaterialApp(title: "Atdel", home: PermissionPages()));
  }
}
