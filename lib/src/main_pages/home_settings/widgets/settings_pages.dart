// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/main_pages/home_settings/credits_pages.dart';

// dev button
/* 
  Intended just for testing function.
*/
class DevButton extends StatelessWidget {
  const DevButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.developer_mode),
      title: const Text("DEV BUTTON"),
      onTap: () {},
    );
  }
}

class CreditsButton extends StatelessWidget {
  const CreditsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.build_circle_sharp),
      title: const Text("Credits"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreditsPage()));
      },
    );
  }
}

class FooterSettings extends StatelessWidget {
  const FooterSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Open Source App By AITI Solution"),
        Text("Made With Flutter"),
        Text("Copyright 2022 Atdel By AITI Solution")
      ],
    );
  }
}
