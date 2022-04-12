// dart
import 'dart:io';

// path
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/home_pages/permission_pages.dart';

// services
import 'package:atdel/src/services/storage_services.dart';

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
      child: Column(children: const [PermissionButton(), DevButton()]),
    );
  }
}

// permission button
class PermissionButton extends StatelessWidget {
  const PermissionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PermissionPages("run")));
        },
        leading: const Icon(Icons.perm_media_rounded),
        title: const Text("Permission"));
  }
}

// dev button
/* 
  Intended just for testing function.
*/
class DevButton extends StatelessWidget {
  const DevButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.developer_mode),
      title: const Text("DEV BUTTON"),
      onTap: () async {
        final StorageService storageService = StorageService();
        final _localPath = await getTemporaryDirectory();
        final _localFile = File(join(_localPath.path, "test_file.txt"));

        // make and read file
        // final writeFile = _localFile.writeAsString("test string\nwow");

        // final contents = await _localFile.readAsString();

        // upload the file
        final uploadReference =
            await storageService.uploadFile(_localFile, "test_file.txt");

        // download the file
        storageService.downloadFile(uploadReference);

        // print(contents);
      },
    );
  }
}
