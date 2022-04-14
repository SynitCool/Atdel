// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_user_room_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';
import 'package:atdel/src/services/room_services.dart';

// model
import 'package:atdel/src/model/user_room.dart';
import 'package:atdel/src/model/room.dart';

// user room page
class UserRoomPage extends StatelessWidget {
  const UserRoomPage({Key? key, required this.userRoom}) : super(key: key);

  final UserRoom userRoom;

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
      Text(selectedUserRoomProvider.userRoom!.displayName,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        selectedUserRoomProvider.userRoom!.email,
        style: const TextStyle(fontSize: 20, color: Colors.black45),
      ),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: const [MakeHostRoomButton(), KickUserRoomButton()]),
      )
    ]);
  }
}

// user room page top
class BuildTop extends ConsumerWidget {
  const BuildTop({Key? key}) : super(key: key);

  final double coverHeight = 180;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double top = coverHeight - profileHeight / 2;
    final double bottom = profileHeight / 2;

    final selectedUserRoomProvider = ref.watch(selectedUserRoom);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: Container(color: Colors.grey, height: coverHeight)),
        Positioned(
            child: CircleAvatar(
              radius: profileHeight / 2,
              backgroundColor: Colors.grey.shade800,
              backgroundImage:
                  NetworkImage(selectedUserRoomProvider.userRoom!.photoUrl),
            ),
            top: top)
      ],
    );
  }
}

// kick user room button
class KickUserRoomButton extends ConsumerWidget {
  const KickUserRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final UserRoomService userRoomService = UserRoomService();

    // providers
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    final selectedRoomProvider = ref.watch(selectedRoom);

    return ElevatedButton.icon(
        onPressed: () {
          userRoomService.removeUserRoom(
              selectedRoomProvider.room!, selectedUserRoomProvider.userRoom!);

          Navigator.pop(context);
        },
        icon: const Icon(Icons.person_remove),
        style: ElevatedButton.styleFrom(primary: Colors.red),
        label: const Text("Kick From The Room"));
  }
}

// make as host room
class MakeHostRoomButton extends ConsumerWidget {
  const MakeHostRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final RoomService roomService = RoomService();

    // providers
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    final selectedRoomProvider = ref.watch(selectedRoom);

    return ElevatedButton.icon(
        onPressed: () {
          final Room oldRoom = Room.copy(selectedRoomProvider.room!);

          final Room newRoom = Room(
              hostEmail: selectedUserRoomProvider.userRoom!.email,
              hostPhotoUrl: selectedUserRoomProvider.userRoom!.photoUrl,
              hostName: selectedUserRoomProvider.userRoom!.displayName,
              hostUid: selectedUserRoomProvider.userRoom!.uid,
              memberCounts: selectedRoomProvider.room!.memberCounts,
              roomDesc: selectedRoomProvider.room!.roomDesc,
              roomName: selectedRoomProvider.room!.roomName,
              id: selectedRoomProvider.room!.id,
              roomCode: selectedRoomProvider.room!.roomCode);

          roomService.updateRoomInfo(oldRoom, newRoom);

          Navigator.pop(context);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.person_add_alt),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        label: const Text("Make as Host Room"));
  }
}
