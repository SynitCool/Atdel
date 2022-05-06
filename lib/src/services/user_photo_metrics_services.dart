// firebase
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// path
import 'package:path_provider/path_provider.dart';

// model
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/selected_users.dart';

// services
import 'package:atdel/src/services/ml_services.dart';
import 'package:atdel/src/services/selected_users_services.dart';
import 'package:atdel/src/services/storage_services.dart';

// linalg
import 'package:ml_linalg/vector.dart';

class UserPhotoMetricService {
  final auth.User? _authUser = auth.FirebaseAuth.instance.currentUser;

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  final String rootRoomReference = "rooms";
  final String usersPhotoMetricReference = "users_photo_metric";

  // update photo metric
  Future updateUserPhotoMetric(Room room, List<dynamic> metric) async {
    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    // check if reference child exist
    final DataSnapshot getReferenceChild = await referenceChild.get();
    if (!getReferenceChild.exists) {
      await referenceChild.set({_authUser!.uid: metric});
      return;
    }

    // check if user metric exist
    final DataSnapshot getReferenceUserMetric =
        await referenceChild.child(_authUser!.uid).get();

    if (getReferenceUserMetric.exists) return;

    // update users photo metric
    await referenceChild.update({_authUser!.uid: metric});
  }

  // check user photo metric exist
  Future<bool> userPhotoMetricExist(Room room) async {
    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    // check if user metric exist
    final DataSnapshot getReferenceUserMetric =
        await referenceChild.child(_authUser!.uid).get();

    if (getReferenceUserMetric.exists) return true;

    return false;
  }

  // update photo metric with selected users photo
  Future updateWithSelectedUsersPhoto(Room room) async {
    // check user photo metric exist
    if (await userPhotoMetricExist(room)) return;

    final SelectedUsersServices _selectedUsersServices =
        SelectedUsersServices();
    final StorageService _storageService = StorageService();

    // get selected users photo
    final selectedUsers = await _selectedUsersServices.getSelectedUsersByEmail(
        room, _authUser!.email!);

    // temp dir
    final tempDir = await getTemporaryDirectory();

    // download image
    final downloadFile = await _storageService.downloadSelectedUsersPhoto(
        room, tempDir, selectedUsers!);

    final MLService _mlService = MLService();

    // set photo metric
    final detectFace = await _mlService.runDetector(downloadFile);

    if (detectFace == "no_face_detected") return "no_face_detected";
    if (detectFace == "more_than_one_face") return "more_than_one_face";

    final runModelMetric = await _mlService.runModel(detectFace);

    await updateUserPhotoMetric(room, runModelMetric);
  }

  // delete user photo metric
  Future deleteUserPhotoMetric(Room room, SelectedUsers selectedUsers) async {
    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    final selectedUserMetric = referenceChild.child(selectedUsers.uid!);

    // check if user metric exist
    final DataSnapshot getReferenceUserMetric = await selectedUserMetric.get();

    if (!getReferenceUserMetric.exists) return;

    await selectedUserMetric.remove();
  }

  // calculate similarity
  Future<String?> calcSmallestUserSimilarity(
      Room room, List<dynamic> metric) async {
    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    // get all metrics
    final DataSnapshot getReferenceChild = await referenceChild.get();

    // check metrics is exist
    if (!getReferenceChild.exists) return null;

    final dynamic data = getReferenceChild.value;

    num? smallestSimilarity;
    String smallestUserUid = '';
    data.forEach((key, value) {
      final vector1 = Vector.fromList(List<num>.from(metric));
      final vector2 = Vector.fromList(List<num>.from(value));

      if (smallestSimilarity == null) {
        smallestSimilarity = vector1.distanceTo(vector2).abs();
        smallestUserUid = key;
        return;
      }

      if (smallestSimilarity! < vector1.distanceTo(vector2).abs()) return;

      smallestSimilarity = vector1.distanceTo(vector2).abs();
      smallestUserUid = key;
    });

    print("Smallest Similarity: $smallestSimilarity");

    if (smallestSimilarity! > 0.7) return null;

    return smallestUserUid;
  }

  // delete room user photo metric
  Future deleteRoomUserPhotoMetric(Room room) async {
    // database reference
    final DatabaseReference reference = _db.ref(rootRoomReference);
    final DatabaseReference referenceChild = reference.child(room.id);

    // delete room user photo metric
    await referenceChild.remove();
  }

  // delete user photo metric based on user
  Future deleteUserPhotoMetricCurrentUser(Room room) async {
    // database reference
    final String referencePath =
        "$rootRoomReference/${room.id}/$usersPhotoMetricReference";
    final DatabaseReference reference = _db.ref(referencePath);
    final DatabaseReference referenceChild = reference.child(_authUser!.uid);

    // delete current user photo metric
    await referenceChild.remove();
  }
}
