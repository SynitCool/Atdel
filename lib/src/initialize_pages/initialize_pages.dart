// flutter
import 'package:atdel/src/auth_pages/signin.dart';
import 'package:atdel/src/main_pages/home/home_pages.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitializePages extends ConsumerWidget {
  const InitializePages({Key? key}) : super(key: key);

  // scenes widget
  final Widget loadingScene =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  final Widget errorScene =
      const Scaffold(body: Center(child: Text("Something went wrong!")));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(currentUser);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          } else if (snapshot.hasData) {
            provider.setCurrentAuthUser();

            return const HomePage();
          } else if (snapshot.hasError) {
            return errorScene;
          } else {
            return const SignInPage();
          }
        });
  }
}
