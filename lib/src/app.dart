import 'package:flutter/material.dart';
import 'package:atdel/src/pages/permission_pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Atdel", home: PermissionPages("start"));
  }
}