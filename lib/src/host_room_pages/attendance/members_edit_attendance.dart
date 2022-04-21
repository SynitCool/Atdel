// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/user_attendance_services.dart';

// model
import 'package:atdel/src/model/user_attendance.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// widgets
import 'package:atdel/src/host_room_pages/attendance/widgets/members_edit_attendance.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';

// page
class MembersEditPage extends ConsumerStatefulWidget {
  const MembersEditPage({Key? key, required this.usersAttendance})
      : super(key: key);

  final List<UserAttendance> usersAttendance;

  @override
  ConsumerState<MembersEditPage> createState() => _MembersEditPageState();
}

class _MembersEditPageState extends ConsumerState<MembersEditPage> {
  final UserAttendanceService _userAttendanceService = UserAttendanceService();

  // scaffold appbar
  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Members Edit"),
      );

  // floating action button
  FloatingActionButton floatingActionButton() {
    final selectedRoomProvider = ref.watch(selectedRoom);
    final selectedAttendanceProvider = ref.watch(selectedAttendance);

    return FloatingActionButton(
        onPressed: () {
          _userAttendanceService.updateUsersAttendance(
              widget.usersAttendance,
              selectedRoomProvider.room!,
              selectedAttendanceProvider.attendance!);

          Navigator.pop(context);
        },
        child: const Icon(Icons.done));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButton(),
        appBar: scaffoldAppBar(),
        body: Column(
          children: [
            const ColumnTile(),
            const Divider(color: Colors.black),
            Expanded(
              child: ListView.builder(
                itemCount: widget.usersAttendance.length,
                itemBuilder: (context, index) {
                  final UserAttendance currentUser =
                      widget.usersAttendance[index];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            currentUser.setAbsent = !currentUser.absent;
                          });
                        },
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(currentUser.photoUrl),
                            radius: 30),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(child: Text(currentUser.alias)),
                              const VerticalDivider(),
                              Expanded(child: Text(currentUser.email)),
                              const VerticalDivider(),
                              Expanded(
                                  child: currentUser.absent
                                      ? const Icon(Icons.check,
                                          color: Colors.green)
                                      : const Icon(Icons.close,
                                          color: Colors.red)),
                            ]),
                      ),
                      const Divider(color: Colors.black)
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}