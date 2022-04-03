// firebase
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';

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

  // calculate similarity
  Future<String> calcSmallestUserSimilarity(Room room, List<dynamic> metric) async {
    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    // get all metrics
    final DataSnapshot getReferenceChild = await referenceChild.get();
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

    return smallestUserUid;
  }
}
