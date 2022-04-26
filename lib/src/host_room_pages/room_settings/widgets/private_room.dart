// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/host_room_pages/room_settings/add_selected_users_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/show_selected_users.dart';

// title selected users
class SelectedUsersTitle extends StatelessWidget {
  const SelectedUsersTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Selected Users", style: TextStyle(color: Colors.grey));
  }
}


// show selected users button
class ShowSelectedUsersButton extends StatelessWidget {
  const ShowSelectedUsersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.people_alt_outlined),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ShowSelectedUsersPage()));
      },
      title: const Text("Show Selected Users"),
    );
  }
}

// add selected users
class AddSelectedUsersButton extends StatelessWidget {
  const AddSelectedUsersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_box),
      subtitle: const Text("Add selected users with GUI."),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddSelectedUsersPage()));
      },
      title: const Text("Add Selected Users"),
    );
  }
}
