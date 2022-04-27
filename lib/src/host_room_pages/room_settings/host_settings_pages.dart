// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/host_settings_pages.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class ContentSettings extends ConsumerWidget {
  const ContentSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          GeneralSections(),
          OptionsSections(),
          PrivateRoomControlSections(),
          DangerZoneSections(),
        ],
      ),
    );
  }
}
