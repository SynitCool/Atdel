// flutter
import 'package:flutter/material.dart';

// pages
import 'package:atdel/src/host_room_pages/attendance/settings_attendance.dart';

// model
import 'package:atdel/src/model/user_attendance.dart';


// settings button
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const SettingsAttendancePage())));
      },
      icon: const Icon(Icons.settings),
      padding: const EdgeInsets.all(15.0),
    );
  }
}

// member info
class MemberInfoWidget extends StatelessWidget {
  const MemberInfoWidget({Key? key, required this.user}) : super(key: key);

  final UserAttendance user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl), radius: 30),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Text(user.alias)),
                const VerticalDivider(),
                Expanded(child: Text(user.email)),
                const VerticalDivider(),
                Expanded(
                    child: user.absent
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.red)),
              ]),
        ),
        const Divider(color: Colors.black)
      ],
    );
  }
}

// view of members
class MemberView extends StatelessWidget {
  const MemberView({Key? key, required this.users}) : super(key: key);

  final List<UserAttendance> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
              backgroundColor: Colors.transparent, radius: 30),
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
                    child: Text("Absent",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
        ),
        const Divider(color: Colors.black),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserAttendance currentUser = users[index];

              return MemberInfoWidget(user: currentUser);
            },
          ),
        ),
      ],
    );
  }
}
