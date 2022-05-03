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

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:atdel/src/widgets/dialog.dart';

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
        content: const Text(
            "Cannot classfied well or wrong image, please ask the host to update your photo for taking the attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // show no face detected warning
  Future showNoFaceDetectedAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            "Cannot get the face, ask the host to update your photo to take attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // show no face detected warning
  Future showMoreThanOneFaceAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            "The photo has more than one face, ask the host to update your photo to take attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // face valid
  bool detectFaceValid(dynamic detectFaceStatus) {
    if (detectFaceStatus == "no_face_detected") {
      toastWidget("There's No Face Detected In Selected Picture!");
      return false;
    }
    if (detectFaceStatus == "more_than_one_face") {
      toastWidget("Detected More Than 1 Face in Selected Picture!");
      return false;
    }

    return true;
  }

  // classified valid
  bool classifiedValid(String? detectedUid, String realUid) {
    if (detectedUid == null) {
      toastWidget(
          "Cannot Be Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      return false;
    }
    if (detectedUid != realUid) {
      toastWidget(
          "Wrong Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // states
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedAttendanceProvider = ref.watch(selectedAttendance);
    final _selectedCurrentUserProvider = ref.watch(currentUser);

    return ListTile(
        shape: const OutlineInputBorder(),
        leading: const Icon(Icons.photo),
        title: const Text("Attend With Image Gallery"),
        onTap: () async {
          SmartDialog.showLoading();

          final _imagePicker = ImagePicker();
          final _userPhotoMetricService = UserPhotoMetricService();
          final _userAttendanceService = UserAttendanceService();

          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          if (file == null) {
            SmartDialog.dismiss();
            return;
          }

          await _userPhotoMetricService
              .updateWithSelectedUsersPhoto(_selectedRoomProvider.room!);

          final _mlService = MLService();

          final detectFace = await _mlService.runDetector(File(file.path));
          
          if (!detectFaceValid(detectFace)) return;

          final runModelMetric = await _mlService.runModel(detectFace);

          final detectedUid =
              await _userPhotoMetricService.calcSmallestUserSimilarity(
                  _selectedRoomProvider.room!, runModelMetric);

          if (!classifiedValid(
              detectedUid, _selectedCurrentUserProvider.user!.uid)) return;

          _userAttendanceService.updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!);

          SmartDialog.dismiss();

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

  // show no face detected warning
  Future showNoFaceDetectedAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            "Cannot get the face, ask the host to update your photo to take attendance!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // show no face detected warning
  Future showMoreThanOneFaceAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "ERROR",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            "The photo has more than one face, ask the host to update your photo to take attendance!"),
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

          final _imagePicker = ImagePicker();
          final _userPhotoMetricService = UserPhotoMetricService();
          final _userAttendanceService = UserAttendanceService();

          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.camera);

          if (file == null) return;

          await _userPhotoMetricService
              .updateWithSelectedUsersPhoto(_selectedRoomProvider.room!);

          final _mlService = MLService();

          final detectFace = await _mlService.runDetector(File(file.path));

          if (detectFace == "no_face_detected") {
            showNoFaceDetectedAlert(context);
            return;
          }
          if (detectFace == "more_than_one_face") {
            showMoreThanOneFaceAlert(context);
            return;
          }

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
        SmartDialog.showLoading();

        _userAttendanceService.updateAbsentUser(
            _selectedCurrentUserProvider.user!,
            _selectedRoomProvider.room!,
            _selectedAttendanceProvider.attendance!);

        SmartDialog.dismiss();

        Navigator.pop(context);
      },
    );
  }
}
