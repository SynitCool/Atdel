// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// services
import 'package:atdel/src/services/selected_users_services.dart';

// model
import 'package:atdel/src/model/selected_users.dart';

// column tile
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
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            VerticalDivider(),
            Expanded(
                child: Text("Email",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            VerticalDivider(),
            Expanded(
                child: Text("Remove",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
    );
  }
}

// stream selected users
class StreamSelectedUsers extends ConsumerWidget {
  const StreamSelectedUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final selectedRoomProvider = ref.watch(selectedRoom);

    // services
    final selectedUserServices = SelectedUsersServices();
    return StreamBuilder<List<SelectedUsers>>(
        stream: selectedUserServices
            .streamSelectedUsers(selectedRoomProvider.room!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreenStream();
          }

          if (snapshot.hasError) return const ErrorSceneStream();

          final data = snapshot.data;

          if (data == null) return const LoadingScreenStream();

          if (data.isEmpty) return const SelectedUsersIsEmptySceneStream();

          return SelectedUsersView(selectedUsers: data);
        });
  }
}

// loading screen stream
class LoadingScreenStream extends StatelessWidget {
  const LoadingScreenStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// error scene stream
class ErrorSceneStream extends StatelessWidget {
  const ErrorSceneStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("ERROR"));
  }
}

// selected users is empty scene stream
class SelectedUsersIsEmptySceneStream extends StatelessWidget {
  const SelectedUsersIsEmptySceneStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("No Selected Users"));
  }
}

// selected users list view
class SelectedUsersView extends StatelessWidget {
  const SelectedUsersView({Key? key, required this.selectedUsers})
      : super(key: key);

  final List<SelectedUsers> selectedUsers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: selectedUsers.length,
        itemBuilder: (context, index) {
          final currentData = selectedUsers[index];

          if (currentData.joined) return const SizedBox();

          return SelectedUsersInfoTile(user: currentData);
        });
  }
}

// selected users info
class SelectedUsersInfoTile extends ConsumerWidget {
  const SelectedUsersInfoTile({Key? key, required this.user}) : super(key: key);

  final SelectedUsers user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final SelectedUsersServices selectedUsersServices = SelectedUsersServices();

    // provider
    final selectedRoomProvider = ref.watch(selectedRoom);

    return Column(
      children: [
        ListTile(
          leading: user.photoUrl == null ? const CircleAvatar(
              backgroundColor: Colors.transparent, radius: 30) : CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl!), radius: 30,),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Text(user.alias)),
                const VerticalDivider(),
                Expanded(child: Text(user.email)),
                const VerticalDivider(),
                Expanded(
                    child: IconButton(
                  onPressed: () async {
                    await selectedUsersServices.removeSelectedUsers(
                        selectedRoomProvider.room!, user);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                )),
              ]),
        ),
        const Divider(color: Colors.black)
      ],
    );
  }
}
