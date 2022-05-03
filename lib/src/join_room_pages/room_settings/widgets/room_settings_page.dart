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

// pages
import 'package:atdel/src/user_pages/room.dart';
import 'package:atdel/src/main_pages/home_pages.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
        SmartDialog.showLoading();

        _roomService.leaveRoom(_selectedRoomProvider.room!);

        SmartDialog.dismiss();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
    );
  }
}

// machine learning related title
class MachineLearningRelatedTitle extends StatelessWidget {
  const MachineLearningRelatedTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Machine Learning Related",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
    );
  }
}

// danger zone title
class DangerZoneTitle extends StatelessWidget {
  const DangerZoneTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "DANGER ZONE",
      style: TextStyle(fontSize: 20, color: Colors.red),
    );
  }
}

// general
class GeneralTitle extends StatelessWidget {
  const GeneralTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "General",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
    );
  }
}

// set join user room button
class SetJoinUserRoomButton extends StatelessWidget {
  const SetJoinUserRoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text("Set User"),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const JoinUserRoomPage()));
      },
    );
  }
}
