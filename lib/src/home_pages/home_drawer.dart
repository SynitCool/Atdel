// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/home_pages/settings_pages.dart';
import 'package:atdel/src/user_pages/user_pages.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

// drawer widget
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  // widget parameters
  final Color color = const Color.fromRGBO(50, 75, 205, 1);
  final Widget space12 = const SizedBox(height: 12);
  final Widget space24 = const SizedBox(height: 24);
  final Widget space16 = const SizedBox(height: 16);
  final Widget divider70 = const Divider(color: Colors.white70);
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20);

  // button in header
  Widget materialHeaderButton(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: const TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: color,
            child: ListView(
              children: [
                space12,
                divider70,
                space24,
                materialHeaderButton(
                    text: "Setting",
                    icon: Icons.settings,
                    onClicked: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPages()));
                    }),
                space24,
                divider70,
                space12,
              ],
            )));
  }
}

// drawer header
class DrawerHeader extends ConsumerWidget {
  const DrawerHeader({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final SizedBox spaceWidth20 = const SizedBox(width: 20);
  final SizedBox spaceHeight4 = const SizedBox(height: 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserProvider = ref.watch(currentUser);
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StatelessUserPage()));
      },
      child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(currentUserProvider.user!.photoUrl)),
              spaceWidth20,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  currentUserProvider.user!.displayName,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                spaceHeight4,
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
