// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/show_selected_users.dart';

// selected users
class ShowSelectedUsersPage extends StatefulWidget {
  const ShowSelectedUsersPage({Key? key}) : super(key: key);

  @override
  State<ShowSelectedUsersPage> createState() => _ShowSelectedUsersPageState();
}

class _ShowSelectedUsersPageState extends State<ShowSelectedUsersPage> {
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Selected Users"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: const ContentShowSelectedUsersPage(),
    );
  }
}

// content show selected users page
class ContentShowSelectedUsersPage extends StatelessWidget {
  const ContentShowSelectedUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [ColumnTile(), Divider(color: Colors.black), StreamSelectedUsers()],
      );
  }
}
