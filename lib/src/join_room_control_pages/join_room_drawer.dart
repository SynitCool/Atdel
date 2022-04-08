import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/user.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

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
    final RoomService roomService = RoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return StreamBuilder<List<User>>(
        stream: roomService.streamUsersRoom(_selectedRoomProvider.room!),
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

  final List<User> users;

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
class MemberButton extends StatelessWidget {
  const MemberButton({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              user.displayName,
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
class HostButton extends StatelessWidget {
  const HostButton({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                      user.displayName,
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
