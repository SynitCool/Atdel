// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/add_selected_users_settings.dart';

// page
class AddSelectedUsersPage extends StatefulWidget {
  const AddSelectedUsersPage({Key? key}) : super(key: key);

  @override
  State<AddSelectedUsersPage> createState() => _AddSelectedUsersPageState();
}

class _AddSelectedUsersPageState extends State<AddSelectedUsersPage> {
  List<Map<String, dynamic>> selectedUsers = [];

  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Add Selected Users"),
        actions: [AddSelectedUsersButton(selectedUsers: selectedUsers)],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: ContentPage(callback: (value) {
        setState(() {
          selectedUsers = value;
        });
      }),
    );
  }
}

// content
class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  // controller
  final TextEditingController userAliasController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();

  // text
  String userAliasText = '';
  String userEmailText = '';

  List<Map<String, dynamic>> addedSelectedUsers = [];

  @override
  void dispose() {
    userAliasController.dispose();
    userEmailController.dispose();
    super.dispose();
  }

  // user alias error text field
  String? get userAliasErrorText {
    final String text = userAliasController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  // user email error text field
  String? get userEmailErrorText {
    final String text = userEmailController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (!text.contains("@")) {
      return 'Email is not valid!';
    }

    return null;
  }

  // user alias text field widget
  Widget userAliasFieldWidget() => TextField(
        controller: userAliasController,
        decoration: InputDecoration(
            label: const Text("User Alias"),
            border: const OutlineInputBorder(),
            errorText: userAliasErrorText),
        onChanged: (text) => setState(() {
          userAliasText = text;
        }),
      );

  // user email text field widget
  Widget userEmailFieldWidget() => TextField(
        controller: userEmailController,
        decoration: InputDecoration(
            label: const Text("User Email"),
            border: const OutlineInputBorder(),
            errorText: userEmailErrorText),
        onChanged: (text) => setState(() {
          userEmailText = text;
        }),
      );

  // add added selected users
  Widget addedSelectedUsersButton() => ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text("Add"),
      onPressed: () {
        if (userAliasText.isEmpty) return;
        if (userEmailText.isEmpty) return;

        if (userAliasText.length < 4) return;
        if (!userEmailText.contains("@")) return;

        if (userAliasText.length > 12) return;

        Map<String, dynamic> selectedUser = {
          "alias": userAliasText,
          "email": userEmailText,
          "joined": false
        };

        setState(() {
          addedSelectedUsers.add(selectedUser);
        });

        widget.callback(addedSelectedUsers);

        userAliasController.clear();
        userEmailController.clear();
      });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const ColumnTile(),
          SizedBox(
            height: height / 3,
            width: width / 3,
            child: ListView.builder(
                itemCount: addedSelectedUsers.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final currentData = addedSelectedUsers[index];

                  return ListTile(
                    leading: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            addedSelectedUsers.removeAt(index);
                          });

                          widget.callback(addedSelectedUsers);
                        }),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(child: Text(currentData["alias"])),
                          const VerticalDivider(),
                          Expanded(child: Text(currentData["email"])),
                        ]),
                  );
                }),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              userAliasFieldWidget(),
              const SizedBox(height: 15),
              userEmailFieldWidget(),
              const SizedBox(height: 10),
              addedSelectedUsersButton()
            ],
          )
        ],
      ),
    );
  }
}
