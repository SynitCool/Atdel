// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/selected_users_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// add selected users to database
class AddSelectedUsersButton extends ConsumerWidget {
  const AddSelectedUsersButton({Key? key, required this.selectedUsers})
      : super(key: key);

  final List<Map<String, dynamic>> selectedUsers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SelectedUsersServices selectedUsersServices = SelectedUsersServices();
    final selectedRoomProvider = ref.watch(selectedRoom);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () async {
            SmartDialog.showLoading();

            await selectedUsersServices.addSelectedUsers(
                selectedRoomProvider.room!, selectedUsers);

            SmartDialog.dismiss();

            Navigator.pop(context);
          },
          icon: const Icon(Icons.add_circle)),
    );
  }
}

// column box
class ColumnTile extends StatelessWidget {
  const ColumnTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          const CircleAvatar(backgroundColor: Colors.transparent, radius: 30),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Expanded(
                child: Text(
              "Photo",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            VerticalDivider(),
            Expanded(
                child: Text(
              "Alias",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            VerticalDivider(),
            Expanded(
                child: Text("Email",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
    );
  }
}
