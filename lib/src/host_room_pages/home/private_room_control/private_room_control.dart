// flutter
import 'package:flutter/material.dart';

// features
import 'package:atdel/src/host_room_pages/home/private_room_control/private_room.dart';
import 'package:atdel/src/host_room_pages/home/private_room_control/public_room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// private room control page
class PrivateRoomControlPage extends ConsumerWidget {
  const PrivateRoomControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomProvider = ref.watch(selectedRoom);
    return selectedRoomProvider.room!.privateRoom
        ? const PrivateRoom()
        : const PublicRoom();
  }
}
