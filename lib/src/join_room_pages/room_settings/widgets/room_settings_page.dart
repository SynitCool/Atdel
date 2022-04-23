// dart
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// picker
import 'package:image_picker/image_picker.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';
import 'package:atdel/src/services/ml_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';


// set image button
class SetImageButton extends ConsumerWidget {
  const SetImageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _mlService = MLService();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    // final _storageService = StorageService();
    return ListTile(
      leading: const Icon(Icons.photo_camera),
      title: const Text("Set Image"),
      onTap: () async {
        final _picker = ImagePicker();

        final XFile? imageXFile =
            await _picker.pickImage(source: ImageSource.gallery);

        if (imageXFile == null) return;

        final detectedFace =
            await _mlService.runDetector(File(imageXFile.path));

        final faceMetric = await _mlService.runModel(detectedFace);

        await _userPhotoMetricService.updateUserPhotoMetric(
            _selectedRoomProvider.room!, faceMetric);
      },
    );
  }
}

// leave room button
class LeaveRoomButton extends ConsumerWidget {
  const LeaveRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _roomService = RoomService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return ElevatedButton.icon(
      icon: const Icon(Icons.time_to_leave),
      style: ElevatedButton.styleFrom(primary: Colors.red),
      label: const Text("Leave Room"),
      onPressed: () {
        Navigator.pop(context);

        _roomService.leaveRoom(_selectedRoomProvider.room!);

        Navigator.pop(context);
      },
    );
  }
}
