import 'package:flutter/material.dart';
import 'package:atdel/src/pages/permission_pages.dart';
import 'package:atdel/src/authentication/firebase_authentication.dart';

import 'package:provider/provider.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(title: "Atdel", home: PermissionPages("start")));
  }
}