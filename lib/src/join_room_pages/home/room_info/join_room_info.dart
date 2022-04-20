// flutter
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// room info pages
class RoomInfo extends StatelessWidget {
  const RoomInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [Title(), ContentInfo()],
      ),
    );
  }
}

// title room info
class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Room Info",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26));
  }
}

// content info
class ContentInfo extends ConsumerWidget {
  const ContentInfo({Key? key}) : super(key: key);

  // column
  Widget columnTable() => ListTile(
        title: Row(
          children: const [
            Expanded(
                child: Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            VerticalDivider(),
            Expanded(
                child: Text("Description",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ],
        ),
      );

  // info room
  Widget roomInfoTable(String title, String desc) => Column(
        children: [
          ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Text(title)),
                  const VerticalDivider(),
                  Expanded(child: Text(desc)),
                ]),
          ),
          const Divider(color: Colors.black)
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        children: [
          columnTable(),
          roomInfoTable("Room Name", _selectedRoomProvider.room!.roomName),
          roomInfoTable("Room Id", _selectedRoomProvider.room!.id),
          roomInfoTable("Room Code", _selectedRoomProvider.room!.roomCode),
          roomInfoTable("Member Counts", _selectedRoomProvider.room!.memberCounts.toString()),
          roomInfoTable("Host Name", _selectedRoomProvider.room!.hostName),
          roomInfoTable("Host Email", _selectedRoomProvider.room!.hostEmail),
          roomInfoTable("Private Room", _selectedRoomProvider.room!.privateRoom ? "yes" : "no")
        ],
      ),
    );
  }
}
