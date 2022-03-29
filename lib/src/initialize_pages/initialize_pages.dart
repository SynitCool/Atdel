// flutter
import 'package:atdel/src/auth_pages/signin_pages.dart';
import 'package:atdel/src/home_pages/home_pages.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

class InitializePages extends StatefulWidget {
  const InitializePages({Key? key}) : super(key: key);

  @override
  State<InitializePages> createState() => _InitializePagesState();
}

class _InitializePagesState extends State<InitializePages> {
  // scenes widget
  Widget loadingScene =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  Widget errorScene =
      const Scaffold(body: Center(child: Text("Something went wrong!")));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          } else if (snapshot.hasData) {
            return const HomePage();
          } else if (snapshot.hasError) {
            return errorScene;
          } else {
            return const SignInPage();
          }
        });
  }
}
