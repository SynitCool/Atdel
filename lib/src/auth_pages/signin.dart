// flutter
import 'package:flutter/material.dart';

// logo
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// authentication
import 'package:atdel/src/authentication/google_authentication.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  PreferredSizeWidget appBarWidget() =>
      AppBar(title: const Text("Sign in"), centerTitle: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      final provider = GoogleSignInProvider();

                      provider.googleLogin();
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