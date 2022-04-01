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

    containerButtonsContainer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: materialDrawerButtons,
      ),
    );
  }

  // drawer host room
  Widget materialHeader(User user) {
    const padding = EdgeInsets.symmetric(horizontal: 20);
    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(user.photoUrl));
    const SizedBox spaceWidth20 = SizedBox(width: 20);
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.home,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            user.displayName,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        user.email,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ]);

    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              avatarPicture,
              spaceWidth20,
              avatarInfoWidget,
            ],
          )),
    );
  }

  // drawer member room
  Widget materialContentButton(User user) {
    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(user.photoUrl));
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            user.displayName,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        user.email,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ]);

    return ListTile(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      leading: avatarPicture,
      title: avatarInfoWidget,
    );
  }

  // drawer content
  Widget materialDrawer(List<User> users) {
    for (final user in users) {
      // check host
      if (user.uid == widget.room.hostUid) {
        materialDrawerWidget.add(materialHeader(user));
        materialDrawerButtons.add(containerButtonsContainer);
      } else {
        setState(() {
          materialDrawerButtons.add(materialContentButton(user));
        });
      }
    }

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
        stream: roomService.streamUsersRoom(widget.room.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final data = snapshot.data;

          return materialDrawer(data!);

          // return ListView.builder(
          //     itemCount: data!.length,
          //     itemBuilder: (context, index) {
          //       final currentData = data[index];

          //       return ElevatedButton(
          //           onPressed: () {}, child: Text(currentData.displayName));
          //     });
        });
  }
}
