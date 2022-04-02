// flutter
import 'package:atdel/src/services/room_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// editor
import 'package:html_editor_enhanced/html_editor.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

// model
import 'package:atdel/src/model/room.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HtmlEditorController controller = HtmlEditorController();

  late Animation<double> _animation;
  late AnimationController _animationController;

  final RoomService _roomService = RoomService();

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

  Bubble reloadButton() {
    return Bubble(
        icon: Icons.refresh,
        iconColor: Colors.white,
        title: "Refresh",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () {
          if (kIsWeb) {
            controller.reloadWeb();
          } else {
            controller.editorController!.reload();
          }
        });
  }

  Bubble buildButton() {
    return Bubble(
        icon: Icons.build,
        iconColor: Colors.white,
        title: "Build",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () async {
          final text = await controller.getText();

          _roomService.changeRoomDesc(widget.room.id, text);

          Navigator.pop(context);
        });
  }

  PreferredSizeWidget scaffoldAppBar() {
    return AppBar(
      title: const Text("Edit"),
    );
  }

  FloatingActionBubble floatingActionButton() {
    return FloatingActionBubble(
        items: [buildButton(), reloadButton()],
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
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: scaffoldAppBar(),
        floatingActionButton: floatingActionButton(),
        body: HtmlEditor(
          controller: controller,
          htmlEditorOptions: const HtmlEditorOptions(
            hint: 'Your text here...',
          ),
        ),
      ),
    );
  }
}
