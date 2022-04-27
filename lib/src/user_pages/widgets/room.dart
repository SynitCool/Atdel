// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_user_room_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/selected_users_services.dart';

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
    final RoomService roomService = RoomService();

    // providers
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    final selectedRoomProvider = ref.watch(selectedRoom);

    return ElevatedButton.icon(
        onPressed: () {
          roomService.kickUserFromRoomPrivateRoom(
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

  // remove host selected user
  Future removeHostSelectedUser(Room room, UserRoom userRoom) async {
    final SelectedUsersServices selectedUsersServices = SelectedUsersServices();

    final selectedUser = await selectedUsersServices.getSelectedUsersByEmail(
        room, userRoom.email);

    if (selectedUser == null) return;

    await selectedUsersServices.removeSelectedUsers(room, selectedUser);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final RoomService roomService = RoomService();

    // providers
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);
    final selectedRoomProvider = ref.watch(selectedRoom);

    return ElevatedButton.icon(
        onPressed: () async {
          await removeHostSelectedUser(
                selectedRoomProvider.room!, selectedUserRoomProvider.userRoom!);

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
              roomCode: selectedRoomProvider.room!.roomCode,
              attendanceWithMl: selectedRoomProvider.room!.attendanceWithMl);

          roomService.updateRoomInfo(oldRoom, newRoom);

          Navigator.pop(context);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.person_add_alt),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        label: const Text("Make as Host Room"));
  }
}

// options title
class OptionsTitle extends StatelessWidget {
  const OptionsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Options",
      style: TextStyle(color: Colors.grey),
    );
  }
}

// settings title
class SettingsTitle extends StatelessWidget {
  const SettingsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Settings",
      style: TextStyle(color: Colors.grey),
    );
  }
}

// change user alias text field
class ChangeUserAliasTextField extends ConsumerStatefulWidget {
  const ChangeUserAliasTextField({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangeUserAliasTextField> createState() =>
      _ChangeUserAliasTextFieldState();
}

class _ChangeUserAliasTextFieldState
    extends ConsumerState<ChangeUserAliasTextField> {
  // widget related
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  // error text field
  String? get errorText {
    final String text = nameTextFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  @override
  void dispose() {
    nameTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // providers
    final selectedRoomProvider = ref.watch(selectedRoom);
    final selectedUserRoomProvider = ref.watch(selectedUserRoom);

    // services
    final UserRoomService userRoomService = UserRoomService();

    return TextField(
      controller: nameTextFieldController,
      decoration: InputDecoration(
          label: const Text("New User Alias"),
          border: const OutlineInputBorder(),
          errorText: errorText,
          suffixIcon: IconButton(
            onPressed: () async {
              if (nameText.isEmpty) return;
              if (nameText.length < 4) return;
              if (nameText.length > 12) return;

              final UserRoom oldUserRoom =
                  UserRoom.copy(selectedUserRoomProvider.userRoom!);

              selectedUserRoomProvider.userRoom!.setAlias = nameText;

              await userRoomService.updateUserRoom(selectedRoomProvider.room!,
                  oldUserRoom, selectedUserRoomProvider.userRoom!);

              nameTextFieldController.clear();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.navigate_next_outlined),
          )),
      onChanged: (text) => setState(() {
        nameText = text;
      }),
    );
  }
}
