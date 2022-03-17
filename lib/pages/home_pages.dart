import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  FloatingActionButton addRoomButton() {
    return FloatingActionButton(
        onPressed: () {}, tooltip: "add room", child: const Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: appBarWidget(),
        floatingActionButton: addRoomButton());
  }
}


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({ Key? key }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  Widget materialHeader() {
    return InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: const Text("Atdel Demo",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }

  Widget materialHeaderButton(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: const TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: onClicked);
  }


  Widget materialDrawer() {
    const Color color = Color.fromRGBO(50, 75, 205, 1);
    const Widget space12 = SizedBox(height: 12);
    const Widget space24 = SizedBox(height: 24);
    const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

    final Widget homeButton =
        materialHeaderButton(text: "Home", icon: Icons.home, onClicked: () {});
    final Widget settingButton = materialHeaderButton(
        text: "Setting", icon: Icons.settings, onClicked: () {});

    List<Widget> materialDrawerButtons = 
    [
      space24, 
      divider70, 
      space12, 
      homeButton, 
      space16, 
      settingButton,
      space24,
      divider70,
      space12
      ];

    List<Widget> materialDrawerWidget = [
      materialHeader(),
      Container(
        padding: padding,
        child: Column(
          children: materialDrawerButtons,
        ),
      )
    ];

    return Material(
        color: color,
        child: ListView(
          children: materialDrawerWidget,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: materialDrawer());
  }
}