import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:atdel/src/pages/signin_pages.dart';
import 'package:atdel/src/pages/home_pages.dart';

import 'package:atdel/src/databases/firebase_firestore.dart' as model;

// ignore: must_be_immutable
class PermissionPages extends StatefulWidget {
  String type;

  PermissionPages(this.type, {Key? key}) : super(key: key);

  @override
  State<PermissionPages> createState() => _PermissionPagesState();
}

class _PermissionPagesState extends State<PermissionPages> {
  List<dynamic> permissions = [Permission.camera];
  List<String> namePermissions = ["Camera"];
  List<String> statusPermissions = ["denied"];

  Widget loadingScene =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  Widget errorScene =
      const Scaffold(body: Center(child: Text("Something went wrong!")));

  @override
  void initState() {
    super.initState();

    listenPermissions();
  }

  // listen for permission
  void listenPermissions() async {
    List<String> statuses = await checkPermission();

    setState(() {
      statusPermissions = statuses;
    });
  }

  // app bar widget
  PreferredSizeWidget appBarWidget() {
    return AppBar(
      title: const Text("Permission Pages"),
      centerTitle: true,
      elevation: 5,
    );
  }

  // permission button
  Widget permissionButton(
      String permissionName, String statusPermission, Permission permission) {
    Color color = Colors.black;

    switch (statusPermission) {
      case "denied":
        color = Colors.red;
        break;
      case "granted":
        color = Colors.green;
        break;
      default:
        color = Colors.black;
    }

    return ElevatedButton(
        onPressed: () async {
          await permission.request();

          listenPermissions();
        },
        child: Text("$permissionName $statusPermission",
            style: TextStyle(color: color)));
  }

  // check permissions
  Future<List<String>> checkPermission() async {
    List<String> statuses = [];

    for (int i = 0; i < permissions.length; i++) {
      Permission permission = permissions[i];

      PermissionStatus status = await permission.status;

      switch (status) {
        case PermissionStatus.denied:
          statuses.add("denied");
          break;
        case PermissionStatus.granted:
          statuses.add("granted");
          break;
        case PermissionStatus.limited:
          statuses.add("limited");
          break;
        case PermissionStatus.permanentlyDenied:
          statuses.add("permanentlyDenied");
          break;
        case PermissionStatus.restricted:
          statuses.add("denied");
          break;
      }
    }

    return statuses;
  }

  // content
  Widget contentWidget() {
    const String text =
        "Running the application smoothly, please to give permission in the below";

    const Widget descriptionTextWidget =
        Text(text, textAlign: TextAlign.center);

    const Widget boxSpace = SizedBox(height: 12);

    List<Widget> columnChildren = [descriptionTextWidget, boxSpace];

    for (int i = 0; i < permissions.length; i++) {
      columnChildren.add(permissionButton(
          namePermissions[i], statusPermissions[i], permissions[i]));
    }

    return Center(
        child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: columnChildren,
            )));
  }

  Widget buildWidget() {
    return Scaffold(appBar: appBarWidget(), body: contentWidget());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == "run") {
      return buildWidget();
    } else {
      return SwitchPages(statusPermissions, buildWidget());
    }
  }
}

// ignore: must_be_immutable
class SwitchPages extends StatefulWidget {
  List<dynamic> statusPermissions;
  Widget buildWidget;

  SwitchPages(this.statusPermissions, this.buildWidget,{Key? key}) : super(key: key);

  @override
  State<SwitchPages> createState() => _SwitchPagesState();
}

class _SwitchPagesState extends State<SwitchPages> {
  // scenes widget
  Widget loadingScene =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  Widget errorScene =
      const Scaffold(body: Center(child: Text("Something went wrong!")));

  // check permission
  Widget checkingPermission() {
    try {
      String singleStatus = widget.statusPermissions.single;

      if (singleStatus == "granted") {
        return streamFirebaseAuth();
      }

      return widget.buildWidget;
    } catch (e) {
      return widget.buildWidget;
    }
  }

  // stream builder user databaser
  Widget streamUserDatabase(String uid) {
    return StreamBuilder<model.User?>(
      stream: model.User.checkAccountStream(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) return HomePage(snapshot.data!);

        return loadingScene;
      },
    );
  }

  // stream builder firebase auth
  Widget streamFirebaseAuth() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          } else if (snapshot.hasData) {
            final userFirebaseUid = snapshot.data!.uid;

            return streamUserDatabase(userFirebaseUid);
          } else if (snapshot.hasError) {
            return errorScene;
          } else {
            return const SignInPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return checkingPermission();
  }
}
