// flutter
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// features
import 'package:atdel/src/host_room_pages/room_settings/settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/attendance_with_ml_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/room_name_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/private_room.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// disperse button
class DisperseButton extends ConsumerWidget {
  const DisperseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _roomService = RoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return ListTile(
      tileColor: Colors.red,
      textColor: Colors.white,
      iconColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      onTap: () {
        SmartDialog.showLoading();

        _roomService.deleteRoomFromDatabase(_selectedRoomProvider.room!);

        SmartDialog.dismiss();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
      title: const Text("Disperse Room"),
      leading: const Icon(Icons.close),
    );
  }
}

// settings room button
class SettingsRoomButton extends StatelessWidget {
  const SettingsRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.room_preferences),
      title: const Text("Set Room"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SetRoomPages()));
      },
    );
  }
}

// attendance with ml option button
class AttendanceWithMlOptionButton extends StatelessWidget {
  const AttendanceWithMlOptionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.change_circle),
      title: const Text("Attendance With ML"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AttendanceWithMlOptionPage()));
      },
    );
  }
}

// room name option button
class RoomNameOptionButton extends StatelessWidget {
  const RoomNameOptionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.settings_applications),
      title: const Text("Room Name"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RoomNameOptionPage()));
      },
    );
  }
}

// general title
class GeneralTitle extends StatelessWidget {
  const GeneralTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("General",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54));
  }
}

// options title
class OptionsTitle extends StatelessWidget {
  const OptionsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Options",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54));
  }
}

// danger zone title
class DangerZoneTitle extends StatelessWidget {
  const DangerZoneTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "DANGER ZONE",
      style: TextStyle(fontSize: 20, color: Colors.red),
    );
  }
}

// private room title
class PrivateRoomControlTitle extends StatelessWidget {
  const PrivateRoomControlTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Private Room Control",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54));
  }
}

// selected users button
class SelectedUsersButton extends StatelessWidget {
  const SelectedUsersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.people_alt_outlined),
      title: const Text("Set Selected Users"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivateRoom()));
      },
    );
  }
}

// general sections
class GeneralSections extends StatelessWidget {
  const GeneralSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        GeneralTitle(),
        SizedBox(
          height: 5,
        ),
        SettingsRoomButton(),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

// options sections
class OptionsSections extends StatelessWidget {
  const OptionsSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        OptionsTitle(),
        SizedBox(
          height: 5,
        ),
        RoomNameOptionButton(),
        SizedBox(height: 10),
        AttendanceWithMlOptionButton(),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

// private room control sections
class PrivateRoomControlSections extends StatelessWidget {
  const PrivateRoomControlSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PrivateRoomControlTitle(),
        SizedBox(
          height: 10,
        ),
        SelectedUsersButton(),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

// danger zone sections
class DangerZoneSections extends StatelessWidget {
  const DangerZoneSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 50,
        ),
        DangerZoneTitle(),
        SizedBox(height: 10),
        DisperseButton()
      ],
    );
  }
}
