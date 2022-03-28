import 'package:flutter/material.dart';

import 'package:atdel/src/pages/permission_pages.dart';

class SettingsPages extends StatelessWidget {
  const SettingsPages({Key? key}) : super(key: key);

  // app bar widget
  PreferredSizeWidget appBarWidget() {
    return AppBar(
      title: const Text("Settings"),
      centerTitle: true,
    );
  }

  // header widget
  Widget headerWidgets(BuildContext context) {
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);
    final Widget permissionButton = ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PermissionPages("run")));
        },
        leading: const Icon(Icons.perm_media_rounded),
        title: const Text("Permission"));

    List<Widget> buttons = [permissionButton];

    return Container(
      padding: padding,
      child: Column(children: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Material(child: ListView(children: [headerWidgets(context)]))
    );
  }
}
