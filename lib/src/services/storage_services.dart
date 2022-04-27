// dart
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// path
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path/path.dart';

// permission
import 'package:permission_handler/permission_handler.dart';

// firebase
import 'package:firebase_storage/firebase_storage.dart';

// model
import 'package:atdel/src/model/room.dart';

class StorageService {
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  Future downloadFile(Reference ref) async {
    // check permission
    const permission = Permission.storage;

    if (await permission.isDenied) {
      final permissionStatus = await permission.request();

      if (permissionStatus.isDenied) return;
    }

    final downloadsPath = await DownloadsPathProvider.downloadsDirectory;

    final downloadFile = File(join(downloadsPath!.path, ref.name));

    if (downloadFile.existsSync()) await downloadFile.delete();

    // final downloadTask = ref.writeToFile(downloadFile);

    // print(await ref.getDownloadURL());

    // downloadTask.asStream().forEach((element) {
    //   print(element.bytesTransferred / element.totalBytes);
    // });
  }

  Future<String> uploadSelectedUsersPhoto(
      Room room, File photoFile, String photoName) async {
    // file info
    final String fileFormat = photoFile.path.split("/").last.split(".").last;

    Reference ref = FirebaseStorage.instance
        .ref("rooms/${room.id}")
        .child("/selected_users")
        .child("/$photoName.$fileFormat");

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': photoFile.path},
    );

    final uploadTask = ref.putFile(photoFile, metadata);

    uploadTask.asStream().forEach((element) {
      debugPrint("Transfered: ${element.bytesTransferred / element.totalBytes}");
    });

    return await ref.getDownloadURL();
  }
}
