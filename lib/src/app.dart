// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/initialize_pages/initialize_pages.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
          title: "Atdel", 
          home: const InitializePages(),
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init()
          ));
  }
}
