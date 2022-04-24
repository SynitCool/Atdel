// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/show_selected_users_edit.dart';

// selected users
class ShowSelectedUsersEditPage extends StatefulWidget {
  const ShowSelectedUsersEditPage({Key? key}) : super(key: key);

  @override
  State<ShowSelectedUsersEditPage> createState() => _ShowSelectedUsersEditPageState();
}

class _ShowSelectedUsersEditPageState extends State<ShowSelectedUsersEditPage> {
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Selected Users"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: const ContentShowSelectedUsersEditPage(),
    );
  }
}

// content show selected users page
class ContentShowSelectedUsersEditPage extends StatelessWidget {
  const ContentShowSelectedUsersEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [ColumnTile(), Divider(color: Colors.black), StreamSelectedUsers()],
      );
  }
}
