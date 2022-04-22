// dart
import 'dart:io';

// path
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/main_pages/widgets/permission_pages.dart';

// services
import 'package:atdel/src/services/storage_services.dart';


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
      onTap: () {
      },
    );
  }
}