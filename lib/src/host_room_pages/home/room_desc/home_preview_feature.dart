// flutter
import 'package:flutter/material.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

// html
import 'package:flutter_html/flutter_html.dart';

// pages
import 'package:atdel/src/host_room_pages/home/room_desc/home_feature.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

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
            context,
            MaterialPageRoute(
                builder: (context) => const EditHome()));
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

// view html
class ViewHtml extends ConsumerWidget {
  const ViewHtml({Key? key}) : super(key: key);

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _roomService = RoomService();
    return StreamBuilder<Room>(
      stream: _roomService.streamGetRoomInfo(_selectedRoomProvider.room!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        return SingleChildScrollView(child: Html(data: data!.roomDesc));
      },
    );
  }
}
