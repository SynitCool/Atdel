import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fab_circular_menu/fab_circular_menu.dart';

class HostRoomPages extends StatefulWidget {
  const HostRoomPages({Key? key}) : super(key: key);

  @override
  State<HostRoomPages> createState() => _HostRoomPagesState();
}

class _HostRoomPagesState extends State<HostRoomPages> {
  PreferredSizeWidget appBar() {
    return AppBar(title: const Text("Host Room Control"));
  }

  Widget floatingActionButton() {
    return FabCircularMenu(children: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.create))
    ]);
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.wallet_giftcard),
          label: "Test"
          ), 
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          label: "Test1"
        )],
    );
  }

  Widget drawer() {
    return const Drawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        floatingActionButton: floatingActionButton(),
        bottomNavigationBar: bottomNavigationBar());
  }
}
