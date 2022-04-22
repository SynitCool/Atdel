// flutter
import 'package:flutter/material.dart';

// html
import 'package:flutter_html/flutter_html.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';


// view html
class ViewHtml extends ConsumerWidget {
  const ViewHtml({Key? key}) : super(key: key);

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _roomService = RoomService();
    return StreamBuilder<Room>(
      stream: _roomService.streamGetRoomInfo(_selectedRoomProvider.room!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        return SingleChildScrollView(child: Html(data: data!.roomDesc));
      },
    );
  }
}
