// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/user_pages/home.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

// drawer widget
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  // button in header
  Widget materialHeaderButton(
          {required String text,
          required IconData icon,
          VoidCallback? onClicked}) =>
      ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(text, style: const TextStyle(color: Colors.white)),
          hoverColor: Colors.white70,
          onTap: onClicked);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: const Color.fromRGBO(50, 75, 205, 1),
            child: ListView(
              children: const [
                DrawerHeader(),
              ],
            )));
  }
}

// drawer header
class DrawerHeader extends ConsumerWidget {
  const DrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserProvider = ref.watch(currentUser);

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StatelessUserPage()));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20).add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(currentUserProvider.user!.photoUrl)),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  currentUserProvider.user!.displayName,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUserProvider.user!.email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ]),
            ],
          )),
    );
  }
}
