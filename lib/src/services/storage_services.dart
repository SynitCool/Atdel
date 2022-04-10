// dart
import 'dart:io';

// path
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path/path.dart';

// permission
import 'package:permission_handler/permission_handler.dart';

// firebase
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Reference> uploadFile(File file, String fileName) async {
    final ref = _storage.ref("files");
    final refChild = ref.child(fileName);

    // final metadata = SettableMetadata(
    //   contentType: 'image/jpeg',
    //   customMetadata: {'picked-file-path': file.path},
    // );

    final uploadTask = refChild.putFile(file);

    uploadTask.asStream().forEach((element) {
      print(element.bytesTransferred / element.totalBytes);
    });

    return uploadTask.snapshot.ref;
  }

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

    final downloadTask = ref.writeToFile(downloadFile);

    print(await ref.getDownloadURL());

    downloadTask.asStream().forEach((element) {
      print(element.bytesTransferred / element.totalBytes);
    });
  }
}
