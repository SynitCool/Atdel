import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene =
      const Center(child: Text("There something went wrong !"));

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

  // avatar info
  Widget avatarInfoWidget(User user) =>
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
      ]);

  // drawer host room
  Widget materialHeader(User user) => InkWell(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20)
                .add(const EdgeInsets.symmetric(vertical: 40)),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 30, backgroundImage: NetworkImage(user.photoUrl)),
                const SizedBox(width: 20),
                avatarInfoWidget(user),
              ],
            )),
      );
      
  // drawer member room
  Widget materialContentButton(User user) => ListTile(
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

  // drawer content
  Widget materialDrawer(List<User> users) {
    materialDrawerWidget = [];
    materialDrawerButtons = [
      space12,
      divider70,
      memberTitle,
      space24,
    ];

    for (final user in users) {
      // check host
      if (user.uid == widget.room.hostUid) {
        materialDrawerWidget.add(materialHeader(user));
      } else {
        materialDrawerButtons.add(materialContentButton(user));
      }
    }

    Widget containerButtonsContainer = Container(
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

  @override
  Widget build(BuildContext context) {
    // return materialDrawer();
    final RoomService roomService = RoomService();

    return StreamBuilder<List<User>>(
        stream: roomService.streamUsersRoom(widget.room),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return materialDrawer(data!);
        });
  }
}
