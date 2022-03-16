import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> drawerWidgets;

  @override
  void initState() {
    super.initState();

    drawerWidgets = drawerHeaderWidgets();
  }

  // drawer header
  Widget drawerHeader() {
    Widget title = const Text("Attendance List",
        style: TextStyle(color: Colors.white, fontSize: 25));

    return DrawerHeader(
        child: title,
        decoration: const BoxDecoration(color: Colors.blue),
        margin: const EdgeInsets.only(),
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0));
  }

  // appbar widget
  PreferredSizeWidget appBarWidget() {
    Widget appBarSettings = IconButton(
      onPressed: () {},
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );

    return AppBar(
      title: const Text("Atdel Demo"),
      actions: [
        appBarSettings,
      ],
      elevation: 5,
    );
  }

  // drawer widgets
  List<Widget> drawerHeaderWidgets() {
    Widget divider5 = const Divider(thickness: 5);
    Widget divider2 = const Divider(thickness: 2);
    Widget homeButton = RawMaterialButton(
      onPressed: () {},
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: const [
            Icon(Icons.home, size: 24.0),
            Text("Home", style: TextStyle(fontSize: 20))
          ])),
    );
    Widget settingsButton = RawMaterialButton(
      onPressed: () {},
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: const [
            Icon(Icons.settings, size: 24.0),
            Text("Settings", style: TextStyle(fontSize: 20))
          ])),
    );

    Widget roomTitle =
        const Text("Rooms", style: TextStyle(fontWeight: FontWeight.bold));

    return [
      drawerHeader(),
      divider5,
      homeButton,
      settingsButton,
      divider5,
      roomTitle,
      divider2,
    ];
  }

  // drawer widget
  Widget drawer() {
    return Drawer(
        child: ListView(
      children: drawerWidgets,
    ));
  }

  FloatingActionButton addRoomButton() {
    return FloatingActionButton(
        onPressed: () {}, tooltip: "add room", child: const Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(),
        appBar: appBarWidget(),
        floatingActionButton: addRoomButton());
  }
}
