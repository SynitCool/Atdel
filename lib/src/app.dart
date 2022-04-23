// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/initialize_pages/initialize_pages.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
        child: MaterialApp(title: "Atdel", home: InitializePages()));
  }
}
