// flutter
import 'package:atdel/src/host_room_control_pages/home_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:databases/firebase_firestore.dart';
import 'package:flutter/material.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

// html
import 'package:flutter_html/flutter_html.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class HomePreviewPage extends StatefulWidget {
  const HomePreviewPage({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<HomePreviewPage> createState() => _HomePreviewPageState();
}

class _HomePreviewPageState extends State<HomePreviewPage>
    with SingleTickerProviderStateMixin {
  // animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  Bubble editButton() {
    return Bubble(
        icon: Icons.edit,
        iconColor: Colors.white,
        title: "Edit",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        room: widget.room,
                      )));
        });
  }

  FloatingActionBubble scaffoldFloatingActionButton() {
    return FloatingActionBubble(
        items: [editButton()],
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        backGroundColor: Colors.blue,
        animation: _animation,
        iconData: Icons.menu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: scaffoldFloatingActionButton(),
        body: ViewHtml(room: widget.room));
  }
}

class ViewHtml extends StatefulWidget {
  const ViewHtml({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<ViewHtml> createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  // services
  final RoomService _roomService = RoomService();

  Widget showHtmlWidget(String htmlData) {
    return SingleChildScrollView(child: Html(data: htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Room>(
      stream: _roomService.streamGetRoomInfo(widget.room.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        return showHtmlWidget(data!.roomDesc);
      },
    );
  }
}
