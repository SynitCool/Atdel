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

// dev attend with ml
class AttendWithML extends StatefulWidget {
  const AttendWithML({Key? key}) : super(key: key);

  @override
  State<AttendWithML> createState() => _AttendWithMLState();
}

class _AttendWithMLState extends State<AttendWithML> {
  String similarityText = "No Similarity";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // AttendByGalleryButton(
        //     callback: (value) => setState(() {
        //           similarityText = "Similarity: ${value["similarity"]}";
        //         })),
        // const SizedBox(
        //   height: 10,
        // ),
        AttendByCameraButton(
            callback: (value) => setState(() {
                  similarityText = "Similarity: ${value["similarity"]}";
                })),
        const SizedBox(
          height: 15,
        ),
        // const DeleteUserPhotoMetric(),
        const SizedBox(
          height: 20,
        ),
        Text(similarityText)
      ],
    );
  }
}

// delete user photo metric
class DeleteUserPhotoMetric extends ConsumerWidget {
  const DeleteUserPhotoMetric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserPhotoMetricService userPhotoMetricService =
        UserPhotoMetricService();

    // states
    final _selectedRoomProvider = ref.watch(selectedRoom);
    final _selectedCurrentUserProvider = ref.watch(currentUser);

    return ListTile(
        shape: const OutlineInputBorder(),
        leading: const Icon(Icons.refresh),
        title: const Text("Refresh User Photo Metric"),
        onTap: () async {
          SmartDialog.showLoading();

          await userPhotoMetricService.deleteUserPhotoMetricUid(
              _selectedRoomProvider.room!,
              _selectedCurrentUserProvider.user!.uid);

          SmartDialog.dismiss();

          // Navigator.pop(context);
        });
  }
}

// attend with ml
// class AttendWithML extends StatelessWidget {
//   const AttendWithML({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         AttendByGalleryButton(callback: callback),
//         const SizedBox(
//           height: 10,
//         ),
//         const AttendByCameraButton()
//       ],
//     );
//   }
// }

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
  const AttendByGalleryButton({Key? key, required this.callback})
      : super(key: key);

  final Function callback;

  // face valid
  bool detectFaceValid(dynamic detectFaceStatus, {String addMessage = ""}) {
    if (detectFaceStatus == "no_face_detected") {
      toastWidget(
          "There's No Face Detected In Selected Picture! " + addMessage);
      return false;
    }
    if (detectFaceStatus == "more_than_one_face") {
      toastWidget(
          "Detected More Than 1 Face in Selected Picture! " + addMessage);
      return false;
    }

    return true;
  }

  // classified valid
  bool classifiedValid(
      Room room, String uid, String? detectedUid, String realUid) {
    final UserPhotoMetricService userPhotoMetricService =
        UserPhotoMetricService();

    if (detectedUid == null) {
      toastWidget(
          "Cannot Be Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      userPhotoMetricService.deleteUserPhotoMetricUid(room, uid);

      return false;
    }
    if (detectedUid != realUid) {
      toastWidget(
          "Wrong Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      userPhotoMetricService.deleteUserPhotoMetricUid(room, uid);

      return false;
    }

    return true;
  }

  // update absent user
  void updateAbsentUser(User currentUser, Room room, Attendance attendance,
      String filePath) async {
    final _mlService = MLService();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _userAttendanceService = UserAttendanceService();

    final detectFace = await _mlService.runDetector(File(filePath));

    if (!detectFaceValid(detectFace,
        addMessage: "Please Attend With Your Photo Face Only!")) return;


    final runModelMetric = await _mlService.runModel(detectFace);

    final detected = await _userPhotoMetricService.calcSmallestUserSimilarity(
        room, runModelMetric);

    callback(detected);

    if (!classifiedValid(
        room, currentUser.uid, detected!["id"], currentUser.uid)) return;

    _userAttendanceService.updateAbsentUser(currentUser, room, attendance);
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

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Updating Photo!")));

          final statusUpdatingPhoto = await _userPhotoMetricService
              .updateWithSelectedUsersPhoto(_selectedRoomProvider.room!);

          if (!detectFaceValid(statusUpdatingPhoto,
              addMessage:
                  "Ask Host To Change Your Photo Of You With One Face Only!")) {
            SmartDialog.dismiss();
            return;
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Photo Updated!")));

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Classifying User")));

          updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!,
              file.path);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Done Classifying User")));

          SmartDialog.dismiss();

          // Navigator.pop(context);
        });
  }
}

// attend with image by camera
class AttendByCameraButton extends ConsumerWidget {
  const AttendByCameraButton({Key? key, required this.callback})
      : super(key: key);

  final Function callback;

  // face valid
  bool detectFaceValid(dynamic detectFaceStatus, {String addMessage = ""}) {
    if (detectFaceStatus == "no_face_detected") {
      toastWidget(
          "There's No Face Detected In Selected Picture! " + addMessage);
      return false;
    }
    if (detectFaceStatus == "more_than_one_face") {
      toastWidget(
          "Detected More Than 1 Face in Selected Picture! " + addMessage);
      return false;
    }

    return true;
  }

  // classified valid
  bool classifiedValid(
      Room room, String uid, String? detectedUid, String realUid) {
    final UserPhotoMetricService userPhotoMetricService =
        UserPhotoMetricService();

    if (detectedUid == null) {
      toastWidget(
          "Cannot Be Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      userPhotoMetricService.deleteUserPhotoMetricUid(room, uid);

      return false;
    }
    if (detectedUid != realUid) {
      toastWidget(
          "Wrong Classified. Change The Selected Picture Or Ask Host To Change Your Picture!");

      userPhotoMetricService.deleteUserPhotoMetricUid(room, uid);

      return false;
    }

    return true;
  }

  // update absent user
  void updateAbsentUser(User currentUser, Room room, Attendance attendance,
      String filePath) async {
    final _mlService = MLService();
    final _userPhotoMetricService = UserPhotoMetricService();
    final _userAttendanceService = UserAttendanceService();

    final detectFace = await _mlService.runDetector(File(filePath));

    if (!detectFaceValid(detectFace,
        addMessage: "Please Attend With Your Face Only!")) return;

    final runModelMetric = await _mlService.runModel(detectFace);

    final detected = await _userPhotoMetricService.calcSmallestUserSimilarity(
        room, runModelMetric);

    callback(detected);

    if (!classifiedValid(
        room, currentUser.uid, detected!["id"], currentUser.uid)) return;

    _userAttendanceService.updateAbsentUser(currentUser, room, attendance);
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

          SmartDialog.showLoading();

          final _imagePicker = ImagePicker();
          final _userPhotoMetricService = UserPhotoMetricService();
          // final _userAttendanceService = UserAttendanceService();

          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.camera);

          if (file == null) {
            SmartDialog.dismiss();
            return;
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Updating Photo!")));

          final statusUpdatingPhoto = await _userPhotoMetricService
              .updateWithSelectedUsersPhoto(_selectedRoomProvider.room!);

          if (!detectFaceValid(statusUpdatingPhoto,
              addMessage:
                  "Ask Host To Change Your Photo Of You With One Face Only!")) {
            SmartDialog.dismiss();
            return;
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Photo Updated!")));

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Classifying User")));

          updateAbsentUser(
              _selectedCurrentUserProvider.user!,
              _selectedRoomProvider.room!,
              _selectedAttendanceProvider.attendance!,
              file.path);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Done Classifying User")));

          SmartDialog.dismiss();

          // Navigator.pop(context);
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
