// flutter
import 'package:flutter/material.dart';


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
      onTap: () {
      },
    );
  }
}