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
import 'package:atdel/src/services/storage_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

class JoinRoomSettings extends StatefulWidget {
  const JoinRoomSettings({Key? key}) : super(key: key);

  @override
  State<JoinRoomSettings> createState() => _JoinRoomSettingsState();
}

class _JoinRoomSettingsState extends State<JoinRoomSettings> {
  PreferredSizeWidget scaffoldAppBar() =>
      AppBar(title: const Text("Join Room Settings"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentPage());
  }
}

// content page
class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text(
            "Machine Learning Related",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
          ),
          SetImageButton(),
          SizedBox(height: 30),
          Text(
            "DANGER ZONE",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          LeaveRoomButton()
        ],
      ),
    );
  }
}

// set image button
class SetImageButton extends ConsumerWidget {
  const SetImageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _mlService = MLService();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _storageService = StorageService();
    return ListTile(
      leading: const Icon(Icons.photo_camera),
      title: const Text("Set Image"),
      onTap: () async {
        final _picker = ImagePicker();

        final XFile? imageXFile =
            await _picker.pickImage(source: ImageSource.gallery);

        if (imageXFile == null) return;

        _storageService.uploadFile(File(imageXFile.path), imageXFile.name);

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
