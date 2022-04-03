// firebase
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/room.dart';

class UserPhotoMetricService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  final String rootRoomReference = "rooms";
  final String usersPhotoMetricReference = "users_photo_metric";

  // make photo metric
  Future addUserPhotoMetric(Room room, List<dynamic> metric) async {
    // auth user
    final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

    // database reference
    final String photoRoomMetricPath = "$rootRoomReference/${room.id}";

    final DatabaseReference reference = _db.ref(photoRoomMetricPath);
    final DatabaseReference referenceChild =
        reference.child(usersPhotoMetricReference);

    // add user photo metric

    await referenceChild.set({
      authUser!.uid: metric 
    });
  }
}
