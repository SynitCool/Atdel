// flutter
import 'package:atdel/src/host_room_control_pages/home_feature.dart';
import 'package:flutter/material.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

class HomePreviewPage extends StatefulWidget {
  const HomePreviewPage({Key? key}) : super(key: key);

  @override
  State<HomePreviewPage> createState() => _HomePreviewPageState();
}

class _HomePreviewPageState extends State<HomePreviewPage> with SingleTickerProviderStateMixin {
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
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
    return Scaffold(floatingActionButton: scaffoldFloatingActionButton(),);
  }
}
