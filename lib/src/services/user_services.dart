// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user.dart' as model;

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootUsersPath = "users";

  // get user info from database
  Future<model.User> getUserInfo(String userUid) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersPath);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(userUid);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return model.User.fromFirestore(getDoc);
  }

  // add user to database
  Future addUserToDatabase(model.User user) async {
    // make collection
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersPath);

    final DocumentReference<Map<String, dynamic>> doc =
        collection.doc(user.uid);

    // user info
    user.userReference = doc;

    final Map<String, dynamic> userInfo = user.toMapUsers();

    // check user in database
    final getDoc = await doc.get();

    if (getDoc.exists) return;

    await doc.set(userInfo);
  }

  // stream user
  Stream<model.User> streamUser(model.User user) {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersPath);

    final DocumentReference<Map<String, dynamic>> doc =
        collection.doc(user.uid);

    final Stream<model.User> snapshot =
        doc.snapshots().map((snap) => model.User.fromMap(snap.data()!));

    return snapshot;
  }
}
