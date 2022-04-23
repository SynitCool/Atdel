// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/host_settings_pages.dart';

// settings page
class HostSettingsPage extends StatefulWidget {
  const HostSettingsPage({Key? key}) : super(key: key);

  @override
  State<HostSettingsPage> createState() => _HostSettingsPageState();
}

class _HostSettingsPageState extends State<HostSettingsPage> {
  // scaffold app bar
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Host Room Settings"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentSettings());
  }
}

// content settings
class ContentSettings extends StatelessWidget {
  const ContentSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          GeneralTitle(),
          SizedBox(
            height: 5,
          ),
          SettingsRoomButton(),
          SizedBox(
            height: 15,
          ),
          OptionsTitle(),
          SizedBox(
            height: 5,
          ),
          RoomNameOptionButton(),
          SizedBox(
            height: 10,
          ),
          PrivateRoomOptionButton(),
          SizedBox(
            height: 10,
          ),
          AttendanceWithMlOptionButton(),
          SizedBox(
            height: 15,
          ),
          PrivateRoomControlTitle(),
          SizedBox(
            height: 10,
          ),
          SelectedUsersButton(),
          SizedBox(
            height: 15,
          ),
          SelectedUsersPicturesMlButton(),
          SizedBox(
            height: 50,
          ),
          DangerZoneTitle(),
          DisperseButton(),
        ],
      ),
    );
  }
}
