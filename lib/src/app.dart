// flutter
import 'package:flutter/material.dart';

// pages
// import 'package:atdel/src/pages/permission_pages.dart';
import 'package:atdel/src/initialize_pages/initialize_pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "Atdel", home: InitializePages());
  }
}
