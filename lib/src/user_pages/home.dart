// flutter
import 'package:flutter/material.dart';

// authentication
import 'package:atdel/src/authentication/google_authentication.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// states
import 'package:atdel/src/states/current_user.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

class StatelessUserPage extends ConsumerWidget {
  const StatelessUserPage({Key? key}) : super(key: key);

  final double coverHeight = 180;
  final double profileHeight = 144;

  // app bar
  PreferredSizeWidget appBarWidget() => AppBar();

  // content the pages
  Widget buildContent(BuildContext context, CurrentUser currentUser) {
    const space8 = SizedBox(height: 8);
    const space16 = SizedBox(height: 16);
    const padding = EdgeInsets.symmetric(horizontal: 20);

    final Widget signOutButton = ListTile(
        onTap: () async {
          final provider = GoogleSignInProvider();

          provider.googleLogout();

          Navigator.pop(context);
        },
        leading: const Icon(Icons.logout),
        title: const Text("Sign out account"));

    return Column(children: [
      space8,
      Text(currentUser.user!.displayName,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      space8,
      Text(
        currentUser.user!.email,
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

  // cover image
  Widget buildCoverImage() {
    return Container(color: Colors.grey, height: coverHeight);
  }

  // profile image
  Widget buildProfileImage(CurrentUser currentUser) {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(currentUser.user!.photoUrl),
    );
  }

  // header or top widget
  Widget buildTop(BuildContext context, CurrentUser currentUser) {
    final double top = coverHeight - profileHeight / 2;
    final double bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(child: buildProfileImage(currentUser), top: top)
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(currentUser);
    return Scaffold(
      appBar: appBarWidget(),
      body: ListView(padding: EdgeInsets.zero, children: [
        buildTop(context, userRef),
        buildContent(context, userRef)
      ]),
    );
  }
}
