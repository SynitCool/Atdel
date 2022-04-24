// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';

// pages
import 'package:atdel/src/user_pages/room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_user_room_providers.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene =
      const Center(child: Text("There something went wrong !"));

  @override
  Widget build(BuildContext context) {
    // return materialDrawer();
    final UserRoomService _userRoomService = UserRoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return StreamBuilder<List<UserRoom>>(
        stream: _userRoomService.streamUsersRoom(_selectedRoomProvider.room!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return ContentDrawer(users: data!);
        });
  }
}

// content drawer
class ContentDrawer extends ConsumerStatefulWidget {
  const ContentDrawer({Key? key, required this.users}) : super(key: key);

  final List<UserRoom> users;

  @override
  ConsumerState<ContentDrawer> createState() => _ContentDrawerState();
}

class _ContentDrawerState extends ConsumerState<ContentDrawer> {
  // widget parameters
  final Widget space12 = const SizedBox(height: 12);
  final Widget space24 = const SizedBox(height: 24);
  // final Widget space16 = SizedBox(height: 16);
  final Widget divider70 = const Divider(color: Colors.white70);
  final Widget memberTitle = const Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Members",
      style: TextStyle(
          color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );

  // content drawer widgets
  List<Widget> materialDrawerWidget = [];

  // content button widgets
  List<Widget> materialDrawerButtons = [];

  // drawer buttons container
  late Widget containerButtonsContainer;

  @override
  void initState() {
    super.initState();

    materialDrawerButtons.addAll([
      space12,
      divider70,
      memberTitle,
      space24,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final _selectedRoomProvider = ref.watch(selectedRoom);

    materialDrawerWidget = [];
    materialDrawerButtons = [
      space12,
      divider70,
      memberTitle,
      space24,
    ];

    for (final user in widget.users) {
      // check host
      if (user.uid == _selectedRoomProvider.room!.hostUid) {
        materialDrawerWidget.add(HostButton(user: user));
      } else {
        materialDrawerButtons.add(MemberButton(user: user));
      }
    }

    containerButtonsContainer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: materialDrawerButtons,
      ),
    );

    materialDrawerWidget.add(containerButtonsContainer);

    // the background widget
    return ListView(
      children: materialDrawerWidget,
    );
  }
}

// member button
class MemberButton extends ConsumerWidget {
  const MemberButton({Key? key, required this.user}) : super(key: key);

  final UserRoom user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return ListTile(
      onTap: () {
        selectedUserRoomProvider.setUserRoom = user;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserRoomPage()));
      },
      leading: CircleAvatar(
          radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              user.alias,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ]),
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
    return InkWell(
      onTap: () {
        selectedUserRoomProvider.setUserRoom = user;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HostUserRoomPage()));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.alias,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ]),
            ],
          )),
    );
  }
}
