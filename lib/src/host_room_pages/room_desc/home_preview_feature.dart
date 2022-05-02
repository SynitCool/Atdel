// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// pages
import 'package:atdel/src/host_room_pages/room_desc/home_feature.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_desc/widgets/home_preview.dart';

// home preview page
class HomePreviewPage extends ConsumerStatefulWidget {
  const HomePreviewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePreviewPage> createState() => _HomePreviewPageState();
}

class _HomePreviewPageState extends ConsumerState<HomePreviewPage>
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

  // edit button
  Bubble editButton() => Bubble(
      icon: Icons.edit,
      iconColor: Colors.white,
      title: "Edit",
      titleStyle: const TextStyle(color: Colors.white),
      bubbleColor: Colors.blue,
      onPress: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const EditHome()));
      });

  // floating action button
  FloatingActionBubble scaffoldFloatingActionButton() => FloatingActionBubble(
      items: [editButton()],
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: Colors.white,
      backGroundColor: Colors.blue,
      animation: _animation,
      iconData: Icons.menu);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: scaffoldFloatingActionButton(),
        body: const ViewHtml());
  }
}
