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

// model
import 'package:atdel/src/model/user.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

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

  // update absent user
  void updateAbsentUser(User currentUser, Room room, Attendance attendance,
      String filePath) async {
    final _mlService = MLService();
    final _userPhotoMetricService = UserPhotoMetricService();
    // final _userAttendanceService = UserAttendanceService();

    final detectFace = await _mlService.runDetector(File(filePath));

    if (!detectFaceValid(detectFace)) return;

    final runModelMetric = await _mlService.runModel(detectFace);

    final detectedUid = await _userPhotoMetricService
        .calcSmallestUserSimilarity(room, runModelMetric);

    if (!classifiedValid(detectedUid, currentUser.uid)) return;

    // _userAttendanceService.updateAbsentUser(currentUser, room, attendance);
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

          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          if (file == null) {
            SmartDialog.dismiss();
            return;
          }

          await _userPhotoMetricService
              .updateWithSelectedUsersPhoto(_selectedRoomProvider.room!);

          updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!,
              file.path);

          SmartDialog.dismiss();

          // Navigator.pop(context);
        });
  }
}

// attend with image by camera
class AttendByCameraButton extends ConsumerWidget {
  const AttendByCameraButton({Key? key}) : super(key: key);

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
