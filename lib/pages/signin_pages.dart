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
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: appBarWidget,
      body: const Center(child: ContentWidgets()),
    );
  }
}

class SignInButtons extends StatefulWidget {
  const SignInButtons({Key? key}) : super(key: key);

  @override
  State<SignInButtons> createState() => _SignInButtonsState();
}

class _SignInButtonsState extends State<SignInButtons> {
  final Widget googleSignInButton = ElevatedButton.icon(
    onPressed: () {},
    icon: const FaIcon(FontAwesomeIcons.google),
    label: const Text("Sign in with google"),
    style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        minimumSize: const Size(double.infinity, 50)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [googleSignInButton],
    );
  }
}

class ContentWidgets extends StatelessWidget {
  const ContentWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [SignInButtons()],
        ));
  }
}
