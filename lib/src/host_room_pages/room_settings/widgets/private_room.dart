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

// title
class SelectedUsersMlTitle extends StatelessWidget {
  const SelectedUsersMlTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Selected Users ML",
        style: TextStyle(color: Colors.grey));
  }
}

// show ml picutres
class ShowSelectedUsersPicturesMlButton extends StatelessWidget {
  const ShowSelectedUsersPicturesMlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.people_alt_outlined),
      onTap: () {},
      title: const Text("Show Selected Users Pictures ML"),
    );
  }
}

// add pictures selected users
class AddSelectedUsersPicturesMlButton extends StatelessWidget {
  const AddSelectedUsersPicturesMlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_box),
      subtitle: const Text("Add selected users pictures with GUI."),
      onTap: () {},
      title: const Text("Add Selected Users Picture ML"),
    );
  }
}

// upload pictures in folder selected users button
class SelectedUsersPicturesMlFileButton extends StatelessWidget {
  const SelectedUsersPicturesMlFileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.upload_file),
      subtitle:
          const Text("Add selected users pictures with pictures in folder."),
      onTap: () {},
      title: Row(children: [
        const Text("Find Folders"),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            tooltip: "help",
            iconSize: 20)
      ]),
    );
  }
}

// upload selected users files button
class SelectedUsersFileButton extends StatelessWidget {
  const SelectedUsersFileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.upload_file),
      subtitle: const Text("Add selected users with uploading excel file."),
      onTap: () {},
      title: Row(children: [
        const Text("Upload file"),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            tooltip: "help",
            iconSize: 20)
      ]),
    );
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
