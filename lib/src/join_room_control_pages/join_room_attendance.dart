// dart package
import 'dart:io';

// flutter
import 'package:atdel/src/services/user_attendance_services.dart';
import 'package:flutter/material.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// image picker
import 'package:image_picker/image_picker.dart';

// services
import 'package:atdel/src/services/ml_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';

class JoinRoomAttendance extends StatefulWidget {
  const JoinRoomAttendance({Key? key}) : super(key: key);

  @override
  State<JoinRoomAttendance> createState() => _JoinRoomAttendanceState();
}

class _JoinRoomAttendanceState extends State<JoinRoomAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Room Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const [AttendByGalleryButton(), AttendByCameraButton()],
        ),
      ),
    );
  }
}

// attend with image by gallery
class AttendByGalleryButton extends ConsumerWidget {
  const AttendByGalleryButton({Key? key}) : super(key: key);

  // show user metric warning
  Future showUserMetricAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content:
            const Text("Image for room must be set before take attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final _mlService = MLService();
    final _imagePicker = ImagePicker();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _userAttendanceService = UserAttendanceService();

    // states
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedCurrentUserProvider = ref.watch(currentUser);

    return ListTile(
        leading: const Icon(Icons.photo),
        title: const Text("Attend With Image Gallery"),
        onTap: () async {
          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          if (file == null) return;

          final detectFace = await _mlService.runDetector(File(file.path));

          final runModelMetric = await _mlService.runModel(detectFace);

          final detectedUid =
              await _userPhotoMetricService.calcSmallestUserSimilarity(
                  _selectedRoomProvider.room!, runModelMetric);

          if (detectedUid == null ||
              detectedUid != _selectedCurrentUserProvider.user!.uid) {
            showUserMetricAlert(context);
          }

          _userAttendanceService.updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!);
        });
  }
}

// attend with image by camera
class AttendByCameraButton extends ConsumerWidget {
  const AttendByCameraButton({Key? key}) : super(key: key);

  // show user metric warning
  Future showUserMetricAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content:
            const Text("Image for room must be set before take attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final _mlService = MLService();
    final _imagePicker = ImagePicker();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _userAttendanceService = UserAttendanceService();

    // states
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedCurrentUserProvider = ref.watch(currentUser);

    return ListTile(
        leading: const Icon(Icons.camera),
        title: const Text("Attend With Camera"),
        onTap: () async {
          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.camera);

          if (file == null) return;

          final detectFace = await _mlService.runDetector(File(file.path));

          final runModelMetric = await _mlService.runModel(detectFace);

          final detectedUid =
              await _userPhotoMetricService.calcSmallestUserSimilarity(
                  _selectedRoomProvider.room!, runModelMetric);

          if (detectedUid == null ||
              detectedUid != _selectedCurrentUserProvider.user!.uid) {
            showUserMetricAlert(context);
          }

          _userAttendanceService.updateAbsentUser(
            _selectedCurrentUserProvider.user!,
            _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!);
        });
  }
}
