// dart
import 'dart:io';

// firebase
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadFile(File file) async {
    final ref = _storage.ref("files");
    final refChild = ref.child("/cool_file.jpg");

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    final uploadTask = refChild.putFile(file, metadata);

    uploadTask.snapshotEvents.forEach((element) {
      print(element.bytesTransferred / element.totalBytes);
    });
  }
}
