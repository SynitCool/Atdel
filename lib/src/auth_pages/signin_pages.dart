// import 'package:atdel/src/authentication/firebase_authentication.dart';
import 'package:authentication/firebase_authentication.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final PreferredSizeWidget appBarWidget =
      AppBar(title: const Text("Sign in"), centerTitle: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget,
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // final provider = Provider.of<GoogleSignInProvider>(
                      //     context,
                      //     listen: false);

                      final provider = GoogleSignInProvider();

                      provider.googleLogin();

                      debugPrint(provider.user?.displayName);
                    },
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: const Text("Sign in with google"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: const Size(double.infinity, 50)),
                  )
                ],
              ))),
    );
  }
}
