// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_user_room_providers.dart';

// widgets
import 'package:atdel/src/user_pages/widgets/room.dart';

// user room page
class UserRoomPage extends StatelessWidget {
  const UserRoomPage({Key? key}) : super(key: key);


  // app bar
  PreferredSizeWidget appBarWidget() => AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: ListView(
          padding: EdgeInsets.zero,
          children: const [BuildTop(), BuildContent()]),
    );
  }
}

// build content
class BuildContent extends ConsumerWidget {
  const BuildContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return Column(children: [
      const SizedBox(height: 8),
      Text(selectedUserRoomProvider.userRoom!.alias,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        selectedUserRoomProvider.userRoom!.email,
        style: const TextStyle(fontSize: 20, color: Colors.black45),
      ),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: const [
              OptionsTitle(),
              MakeHostRoomButton(),
              KickUserRoomButton(),
            ]),
      )
    ]);
  }
}


// user room page
class HostUserRoomPage extends StatelessWidget {
  const HostUserRoomPage({Key? key}) : super(key: key);


  // app bar
  PreferredSizeWidget appBarWidget() => AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: ListView(
          padding: EdgeInsets.zero,
          children: const [BuildTop(), BuildContentHostUserRoom()]),
    );
  }
}

// build content
class BuildContentHostUserRoom extends ConsumerWidget {
  const BuildContentHostUserRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return Column(children: [
      const SizedBox(height: 8),
      Text(selectedUserRoomProvider.userRoom!.alias,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        selectedUserRoomProvider.userRoom!.email,
        style: const TextStyle(fontSize: 20, color: Colors.black45),
      ),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: const [
              SettingsTitle(),
              SizedBox(height: 10),
              ChangeUserAliasTextField(),
            ]),
      )
    ]);
  }
}



// join user room page
class JoinUserRoomPage extends StatelessWidget {
  const JoinUserRoomPage({Key? key}) : super(key: key);

  // app bar
  PreferredSizeWidget appBarWidget() => AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: ListView(
          padding: EdgeInsets.zero,
          children: const [BuildTop(), BuildContentHostUserRoom()]),
    );
  }
}

// join user room build content
class BuildContentJoinUserRoom extends ConsumerWidget {
  const BuildContentJoinUserRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    return Column(children: [
      const SizedBox(height: 8),
      Text(selectedUserRoomProvider.userRoom!.alias,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        selectedUserRoomProvider.userRoom!.email,
        style: const TextStyle(fontSize: 20, color: Colors.black45),
      ),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: const [
              SettingsTitle(),
              SizedBox(height: 10),
              ChangeUserAliasTextField(),
            ]),
      )
    ]);
  }
}




