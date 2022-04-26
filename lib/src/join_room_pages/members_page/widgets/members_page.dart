// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/user_room.dart';

// member button
class MemberButton extends StatelessWidget {
  const MemberButton({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      tileColor: Colors.white54,
      leading: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
            radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
      ),
      title: Text(
        user.alias,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// host button
class HostButton extends StatelessWidget {
  const HostButton({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      tileColor: Colors.white54,
      leading: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
            radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
      ),
      title: Text(
        user.alias,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// host title
class HostTitle extends StatelessWidget {
  const HostTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Host",
      style: TextStyle(fontSize: 32),
    );
  }
}

// member title
class MemberTitle extends StatelessWidget {
  const MemberTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Members",
      style: TextStyle(fontSize: 32),
    );
  }
}

// members page divider
class MembersPageDivider extends StatelessWidget {
  const MembersPageDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black,
    );
  }
}
