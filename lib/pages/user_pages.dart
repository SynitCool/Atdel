import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:atdel/authentication/firebase_authentication.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  User user;

  UserPage(this.user, {Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String name;
  late String email;
  late String imageUrl;

  final double coverHeight = 180;
  final double profileHeight = 144;

  @override
  void initState() {
    super.initState();

    name = widget.user.displayName!;
    email = widget.user.email!;
    imageUrl = widget.user.photoURL!;
  }

  // cover image
  Widget buildCoverImage() {
    return Container(color: Colors.grey, height: coverHeight);
  }

  // profile image
  Widget buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(imageUrl),
    );
  }

  // header or top widget
  Widget buildTop() {
    final double top = coverHeight - profileHeight / 2;
    final double bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(child: buildProfileImage(), top: top)
      ],
    );
  }

  // content the pages
  Widget buildContent() {
    const space8 = SizedBox(height: 8);
    const space16 = SizedBox(height: 16);
    const padding = EdgeInsets.symmetric(horizontal: 20);

    final Widget signOutButton = ListTile(
        onTap: () async {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);

          provider.googleLogout();

          Navigator.pop(context);
        },
        leading: const Icon(Icons.logout),
        title: const Text("Sign out account"));

    return Column(children: [
      space8,
      Text(name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      space8,
      Text(
        email,
        style: const TextStyle(fontSize: 20, color: Colors.black45),
      ),
      space16,
      const Divider(),
      space16,
      Container(
        padding: padding,
        child: Column(children: [signOutButton]),
      )
    ]);
  }

  PreferredSizeWidget appBarWidget() => AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: ListView(
          padding: EdgeInsets.zero, children: [buildTop(), buildContent()]),
    );
  }
}
