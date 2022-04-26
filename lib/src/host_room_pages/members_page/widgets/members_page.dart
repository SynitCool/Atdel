// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// model
import 'package:atdel/src/model/user_room.dart';

// providers
import 'package:atdel/src/providers/selected_user_room_providers.dart';

// page
import 'package:atdel/src/user_pages/room.dart';

// member button
class MemberButton extends ConsumerWidget {
  const MemberButton({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return ListTile(
      tileColor: Colors.white54,
      onTap: () {
        selectedUserRoomProvider.setUserRoom = user;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UserRoomPage()));
      },
      leading: CircleAvatar(
          radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
      title: Text(
        user.alias,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// host button
class HostButton extends ConsumerWidget {
  const HostButton({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return ListTile(
      tileColor: Colors.white54,
      onTap: () {
        selectedUserRoomProvider.setUserRoom = user;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HostUserRoomPage()));
      },
      leading: CircleAvatar(
          radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
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
