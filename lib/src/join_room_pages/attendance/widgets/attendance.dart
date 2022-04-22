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

// permission
import 'package:permission_handler/permission_handler.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';
import 'package:atdel/src/providers/selected_attendance_providers.dart';
import 'package:atdel/src/providers/selected_room_providers.dart';



// attend with ml
class AttendWithML extends StatelessWidget {
  const AttendWithML({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        AttendByGalleryButton(),
        SizedBox(
          height: 10,
        ),
        AttendByCameraButton()
      ],
    );
  }
}

// attend with no ml
class AttendWithNoMl extends StatelessWidget {
  const AttendWithNoMl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [AttendWithNoMlButton()],
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
        shape: const OutlineInputBorder(),
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
          if (detectedUid == null ||
              detectedUid != _selectedCurrentUserProvider.user!.uid) {
            return;
          }

          _userAttendanceService.updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!);

          Navigator.pop(context);
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
        shape: const OutlineInputBorder(),
        leading: const Icon(Icons.camera),
        title: const Text("Attend With Camera"),
        onTap: () async {
          const permission = Permission.camera;

          if (await permission.isDenied) {
            final permissionStatus = await permission.request();

            if (permissionStatus.isDenied) return;
          }

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
          if (detectedUid == null ||
              detectedUid != _selectedCurrentUserProvider.user!.uid) {
            return;
          }

          _userAttendanceService.updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!);

          Navigator.pop(context);
        });
  }
}

// attend with no ml
class AttendWithNoMlButton extends ConsumerWidget {
  const AttendWithNoMlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final _userAttendanceService = UserAttendanceService();

    // states
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedCurrentUserProvider = ref.watch(currentUser);

    return ListTile(
      shape: const OutlineInputBorder(),
      leading: const Icon(Icons.check),
      title: const Text("Attend"),
      onTap: () async {
        _userAttendanceService.updateAbsentUser(
            _selectedCurrentUserProvider.user!,
            _selectedRoomProvider.room!,
            _selectedAttendanceProvider.attendance!);

        Navigator.pop(context);
      },
    );
  }
}
