// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';

// model
import 'package:atdel/src/model/user_room.dart';

// widgets
import 'package:atdel/src/join_room_pages/members_page/widgets/members_page.dart';

// page
class MembersPage extends ConsumerWidget {
  const MembersPage({Key? key}) : super(key: key);

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene =
      const Center(child: Text("There something went wrong !"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          return ContentPage(users: data!);
        });
  }
}

// content page
class ContentPage extends ConsumerStatefulWidget {
  const ContentPage({Key? key, required this.users}) : super(key: key);

  final List<UserRoom> users;

  @override
  ConsumerState<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
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

    materialDrawerWidget = [const HostTitle(), const MembersPageDivider()];
    materialDrawerButtons = [
      space24,
      const MemberTitle(),
      const MembersPageDivider(),
    ];

    for (final user in widget.users) {
      // check host
      if (user.uid == _selectedRoomProvider.room!.hostUid) {
        materialDrawerWidget.add(HostButton(user: user));
      } else {
        materialDrawerButtons.add(MemberButton(user: user));
      }
    }

    containerButtonsContainer = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: materialDrawerButtons,
    );

    materialDrawerWidget.add(containerButtonsContainer);

    // the background widget
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: materialDrawerWidget,
      ),
    );
  }
}
