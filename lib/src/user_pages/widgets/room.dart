// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_user_room_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/user_room.dart';

// services
import 'package:atdel/src/services/user_room_services.dart';
import 'package:atdel/src/services/room_services.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
          SmartDialog.showLoading();

          roomService.kickUserFromRoomPrivateRoom(
              selectedRoomProvider.room!, selectedUserRoomProvider.userRoom!);

          SmartDialog.dismiss();

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
        onPressed: () async {
          SmartDialog.showLoading();

          roomService.changeHostRoom(
              selectedRoomProvider.room!, selectedUserRoomProvider.userRoom!);

          SmartDialog.dismiss();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
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

  // check name text is valid
  bool nameTextValid() {
    if (nameText.isEmpty) {
      toastWidget("New User Name Supposed Not To Be Empty!");
      return false;
    }
    if (nameText.length < 4) {
      toastWidget(
          "New User Name Length Supposed Not To Be Less Than 4 Characters");
      return false;
    }
    if (nameText.length > 12) {
      toastWidget(
          "New User Name Length Supposed Not To Be Greater Than 12 Characters");
      return false;
    }

    return true;
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
              if (!nameTextValid()) return;

              SmartDialog.showLoading();

              final UserRoom oldUserRoom =
                  UserRoom.copy(selectedUserRoomProvider.userRoom!);

              selectedUserRoomProvider.userRoom!.setAlias = nameText;

              await userRoomService.updateUserRoom(selectedRoomProvider.room!,
                  oldUserRoom, selectedUserRoomProvider.userRoom!);

              nameTextFieldController.clear();
              SmartDialog.dismiss();

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
