// flutter
import 'package:flutter/material.dart';

// logo button
class LogoButton extends StatelessWidget {
  const LogoButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onPressed,
    );
  }
}

// find us title
class FindUsTitle extends StatelessWidget {
  const FindUsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Find Us On",
      style: TextStyle(fontSize: 24, color: Colors.grey),
    );
  }
}

// credits title
class CreditsTitle extends StatelessWidget {
  const CreditsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Credits",
      style: TextStyle(fontSize: 24, color: Colors.grey),
    );
  }
}

// credits content
class CreditsContent extends StatelessWidget {
  const CreditsContent({Key? key, required this.credits}) : super(key: key);

  final List<Map<String, dynamic>> credits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Thank you for third party library for making this app happened"),
        const SizedBox(height: 20),
        ...credits.map((data) => Credits(theme: data["theme"], credit: data["credit"]))
      ],
    );
  }
}

// credits
class Credits extends StatelessWidget {
  const Credits({Key? key, required this.theme, required this.credit})
      : super(key: key);

  final String theme;
  final String credit;

  @override
  Widget build(BuildContext context) {
    return Text("$theme By $credit");
  }
}
