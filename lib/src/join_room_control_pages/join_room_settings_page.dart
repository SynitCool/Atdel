// dart
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';

// picker
import 'package:image_picker/image_picker.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';
import 'package:atdel/src/services/ml_services.dart';

class JoinRoomSettings extends StatefulWidget {
  const JoinRoomSettings({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<JoinRoomSettings> createState() => _JoinRoomSettingsState();
}

class _JoinRoomSettingsState extends State<JoinRoomSettings> {
  PreferredSizeWidget scaffoldAppBar() {
    return AppBar(title: const Text("Join Room Settings"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: scaffoldAppBar(), body: ContentPage(room: widget.room));
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final RoomService _roomService = RoomService();
  final MLService _mlService = MLService();
  final UserPhotoMetricService _userPhotoMetricService =
      UserPhotoMetricService();

  // widget
  Widget mlRelatedText = const Text(
    "Machine Learning Related",
    style: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
  );
  Widget dangerZoneText = const Text(
    "DANGER ZONE",
    style: TextStyle(fontSize: 20, color: Colors.red),
  );

  // leave room button
  Widget leaveRoomButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.time_to_leave),
      style: ElevatedButton.styleFrom(primary: Colors.red),
      label: const Text("Leave Room"),
      onPressed: () {
        Navigator.pop(context);

        _roomService.leaveRoom(widget.room);

        Navigator.pop(context);
      },
    );
  }

  // set image for ml
  Widget setImageButton() {
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
            widget.room, faceMetric);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          mlRelatedText,
          setImageButton(),
          const SizedBox(height: 30),
          dangerZoneText,
          leaveRoomButton()
        ],
      ),
    );
  }
}
