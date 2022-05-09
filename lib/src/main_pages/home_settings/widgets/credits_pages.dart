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
