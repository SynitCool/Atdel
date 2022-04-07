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

class EditHome extends StatefulWidget {
  const EditHome({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  _EditHomeState createState() => _EditHomeState();
}

class _EditHomeState extends State<EditHome>
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

  // reload button
  Bubble reloadButton() => Bubble(
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

  // build button
  Bubble buildButton() => Bubble(
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

  // app bar
  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Edit"),
      );

  // floating action button
  FloatingActionBubble floatingActionButton() => FloatingActionBubble(
      items: [buildButton(), reloadButton()],
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: Colors.white,
      backGroundColor: Colors.blue,
      animation: _animation,
      iconData: Icons.menu);

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
