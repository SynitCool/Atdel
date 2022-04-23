// flutter
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// features
import 'package:atdel/src/host_room_pages/room_settings/settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/private_room_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/attendance_with_ml_settings.dart';
import 'package:atdel/src/host_room_pages/room_settings/room_name_settings.dart';
import 'package:atdel/src/host_room_pages/private_room_control/private_room.dart';

// disperse button
class DisperseButton extends ConsumerWidget {
  const DisperseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _roomService = RoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.pop(context);

          _roomService.deleteRoomFromDatabase(_selectedRoomProvider.room!);

          Navigator.pop(context);
        },
        child: const Text("Disperse Room"));
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

// private room option button
class PrivateRoomOptionButton extends StatelessWidget {
  const PrivateRoomOptionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.privacy_tip),
      title: const Text("Private Room"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrivateRoomSettingsPage()));
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

// selected users pictures for ml button
class SelectedUsersPicturesMlButton extends StatelessWidget {
  const SelectedUsersPicturesMlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.picture_in_picture_sharp),
      title: const Text("Set Selected Users Pictures ML"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivatePicturesRoom()));
      },
    );
  }
}
