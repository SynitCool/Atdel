import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:atdel/src/pages/signin_pages.dart';
import 'package:atdel/src/pages/home_pages.dart';

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

  // check and move to home pages
  Widget switchPages() {
    try {
      String singleStatus = statusPermissions.single;

      if (singleStatus == "granted") {
        return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const HomePage();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong!"),
                );
              } else {
                return const SignInPage();
              }
            });
      }

      return buildWidget();
    } catch (e) {
      return buildWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == "run") {
      return buildWidget();
    } else {
      return switchPages();
    }
  }
}
