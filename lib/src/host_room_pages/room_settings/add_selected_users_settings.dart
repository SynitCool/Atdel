// dart
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// pick file
import 'package:image_picker/image_picker.dart';

// widgets
import 'package:atdel/src/host_room_pages/room_settings/widgets/add_selected_users_settings.dart';

// services
import 'package:atdel/src/services/selected_users_services.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:atdel/src/widgets/dialog.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// model
import 'package:atdel/src/model/selected_users.dart';

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
class ContentPage extends ConsumerStatefulWidget {
  const ContentPage({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  ConsumerState<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  // services
  final SelectedUsersServices _selectedUsersServices = SelectedUsersServices();

  // controller
  final TextEditingController userAliasController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();

  // text
  String userAliasText = '';
  String userEmailText = '';

  // file
  XFile? userPhoto;

  List<Map<String, dynamic>> addedSelectedUsers = [];
  List<String> usersAlias = [];
  List<String> usersEmail = [];

  // selected users in database
  List<SelectedUsers> selectedUsersDatabase = [];

  // name text widget
  String nameFile = "Upload Photo User";

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
            errorText: userAliasErrorText,
            prefixIcon: const Icon(Icons.person)),
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
            errorText: userEmailErrorText,
            prefixIcon: const Icon(Icons.email)),
        onChanged: (text) => setState(() {
          userEmailText = text;
        }),
      );

  // check user alias valid
  bool userAliasValid() {
    if (userAliasText.isEmpty) {
      toastWidget("User Alias Supposed Not To Be Empty!");
      return false;
    }
    if (userAliasText.length < 4) {
      toastWidget(
          "User Alias Length Supposed Not To Be Less Than 4 Characters!");
      return false;
    }
    if (userAliasText.length > 12) {
      toastWidget(
          "User Alias Length Supposed Not To Be Greater Than 12 Characters!");
      return false;
    }

    return true;
  }

  // check email valid
  bool emailValid() {
    if (userEmailText.isEmpty) {
      toastWidget("User Email Supposed Not To Be Empty!");
      return false;
    }
    if (!userEmailText.contains("@")) {
      toastWidget("User Email Is Not Valid!");
      return false;
    }

    return true;
  }

  // check user photo valid
  bool userPhotoValid() {
    if (userPhoto == null) {
      toastWidget("User Photo Supposed Not To Be Empty!");
      return false;
    }

    return true;
  }

  // check duplicate user
  bool duplicateUser() {
    if (usersAlias.contains(userAliasText)) {
      toastWidget("User Alias Supposed To Be Unique!");
      return true;
    }
    if (usersEmail.contains(userEmailText)) {
      toastWidget("User Email Supposed To Be Unique!");
      return true;
    }

    return false;
  }

  // add added selected users
  Widget addedSelectedUsersButton() => ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text("Add"),
      onPressed: () async {
        final selectedRoomProvider = ref.watch(selectedRoom);

        if (selectedUsersDatabase.isEmpty) {
          selectedUsersDatabase = await _selectedUsersServices
              .getSelectedUsers(selectedRoomProvider.room!);

          usersAlias.addAll(selectedUsersDatabase.map((data) => data.alias));
          usersEmail.addAll(selectedUsersDatabase.map((data) => data.email));
        }

        if (!userAliasValid()) return;
        if (!emailValid()) return;
        if (!userPhotoValid()) return;
        if (duplicateUser()) return;

        SmartDialog.showLoading();

        Map<String, dynamic> selectedUser = {
          "alias": userAliasText,
          "email": userEmailText,
          "joined": false,
          "photo_url": null,
          "photo_file": userPhoto,
          "uid": null
        };

        setState(() {
          addedSelectedUsers.add(selectedUser);
          usersAlias.add(userAliasText);
          usersEmail.add(userEmailText);
          userPhoto = null;
        });

        widget.callback(addedSelectedUsers);

        userAliasController.clear();
        userEmailController.clear();

        nameFile = "Upload Photo User";

        userPhoto = null;

        SmartDialog.dismiss();
      });

  // upload photo user
  Widget uploadPhotoUserButton() => ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: userPhoto == null ? Colors.red : Colors.blue),
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();

        final pickImage = await _picker.pickImage(source: ImageSource.gallery);

        if (pickImage == null) return;

        setState(() {
          userPhoto = pickImage;
          nameFile = userPhoto!.name;
        });
      },
      icon: const Icon(Icons.add),
      label: userPhoto == null ? Text("Required $nameFile") : Text(nameFile));

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

                          usersAlias.remove(currentData["alias"]);
                          usersEmail.remove(currentData["email"]);

                          widget.callback(addedSelectedUsers);
                        }),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: currentData["photo_file"] == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.blue, radius: 30)
                                : CircleAvatar(
                                    backgroundImage: FileImage(
                                        File(currentData["photo_file"].path)),
                                    radius: 30),
                          ),
                          const VerticalDivider(),
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
              const SizedBox(height: 15),
              uploadPhotoUserButton(),
              const SizedBox(height: 10),
              addedSelectedUsersButton(),
            ],
          )
        ],
      ),
    );
  }
}
