// dart package
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/attendance.dart';

// image picker
import 'package:image_picker/image_picker.dart';

// services
import 'package:atdel/src/services/room_services.dart';
import 'package:atdel/src/services/ml_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';

class JoinRoomAttendance extends StatefulWidget {
  const JoinRoomAttendance(
      {Key? key, required this.room, required this.attendance})
      : super(key: key);

  final Room room;
  final Attendance attendance;

  @override
  State<JoinRoomAttendance> createState() => _JoinRoomAttendanceState();
}

class _JoinRoomAttendanceState extends State<JoinRoomAttendance> {
  final RoomService _roomService = RoomService();
  final ImagePicker _imagePicker = ImagePicker();
  final MLService _mlService = MLService();
  final UserPhotoMetricService _userPhotoMetricService =
      UserPhotoMetricService();

  // get image by gallery
  Widget pickImageByGallery() {
    return ListTile(
        leading: const Icon(Icons.photo),
        title: const Text("Attend With Image Gallery"),
        onTap: () async {
          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          if (file == null) return;

          final detectFace = await _mlService.runDetector(File(file.path));

          final runModelMetric = await _mlService.runModel(detectFace);

          await _userPhotoMetricService.updateUserPhotoMetric(
              widget.room, runModelMetric);

          await _userPhotoMetricService.calcUserSimilarity(
              widget.room, runModelMetric);
        });
  }

  // get image by camera
  Widget pickImageByCamera() {
    return ListTile(
        leading: const Icon(Icons.camera),
        title: const Text("Attend With Camera"),
        onTap: () async {
          final XFile? file =
              await _imagePicker.pickImage(source: ImageSource.camera);

          if (file == null) return;

          final detectFace = await _mlService.runDetector(File(file.path));

          final runModelMetric = await _mlService.runModel(detectFace);

          await _userPhotoMetricService.updateUserPhotoMetric(
              widget.room, runModelMetric);

          await _userPhotoMetricService.calcUserSimilarity(
              widget.room, runModelMetric);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Room Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [pickImageByGallery(), pickImageByCamera()],
        ),
      ),
      // Center(
      //     child: ElevatedButton(
      //         onPressed: () {
      //           _roomService.updateAbsentUser(widget.room, widget.attendance);
      //         },
      //         child: const Text("Attend")))
    );
  }
}
