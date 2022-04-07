// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/home_pages/permission_pages.dart';

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

  // permission button
  Widget permissionButton() => ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PermissionPages("run")));
      },
      leading: const Icon(Icons.perm_media_rounded),
      title: const Text("Permission"));

  // header widget
  Widget headerWidgets() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [permissionButton()]),
      );

  // dev button
  Widget devButton() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListTile(
        leading: const Icon(Icons.developer_mode),
        title: const Text("DEV BUTTON"),
        onTap: () {},
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(),
        body: Material(child: ListView(children: [headerWidgets()])));
  }
}
