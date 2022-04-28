// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/main_pages/home_settings/widgets/settings_pages.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({Key? key}) : super(key: key);

  @override
  State<SettingsPages> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  // app bar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(),
        body: Material(child: ListView(children: const [ContentSettings()])));
  }
}

// content settings
class ContentSettings extends StatelessWidget {
  const ContentSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: const [DevButton()]),
    );
  }
}
