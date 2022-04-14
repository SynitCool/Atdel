// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/user.dart' as model;
import 'package:atdel/src/model/room.dart';

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

  // remove room reference from user uid
  Future removeRoomReference(String userUid, Room room) async {
    // collection users
    final CollectionReference<Map<String, dynamic>> collectionUsers =
        _db.collection(rootUsersPath);

    final DocumentReference<Map<String, dynamic>> docUser = collectionUsers.doc(userUid);

    // remove room reference
    final getDocUser = await docUser.get();

    final user = model.User.fromFirestore(getDocUser);

    user.roomReferences.remove(_db.collection("rooms").doc(room.id));

    final userMap = user.toMap();

    // set the database
    await docUser.set(userMap);
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

    final Map<String, dynamic> userInfo = user.toMap();

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
