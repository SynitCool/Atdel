// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// model
import 'package:atdel/src/model/user.dart' as model;
import 'package:atdel/src/model/room.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth.User? authUser = auth.FirebaseAuth.instance.currentUser;

  final String rootUsersCollection = "users";
  final String rootRoomsCollection = "rooms";

  // add room reference
  Future addRoomReference(Room room) async {
    // users collections
    final CollectionReference<Map<String, dynamic>> usersCollection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> usersDoc =
        usersCollection.doc(authUser!.uid);

    // update user room reference
    model.User oldUser = model.User.fromFirestore(await usersDoc.get());
    model.User newUser = model.User.copy(oldUser);

    newUser.roomReferences.add(_db.collection(rootRoomsCollection).doc(room.id));

    await updateUser(oldUser, newUser);

    return newUser;
  }

  // get user info from database
  Future<model.User> getUserInfo(String userUid) async {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> doc = collection.doc(userUid);

    final DocumentSnapshot<Map<String, dynamic>> getDoc = await doc.get();

    return model.User.fromFirestore(getDoc);
  }

  // remove room reference from user uid
  Future removeRoomReference(String userUid, Room room) async {
    // collection users
    final CollectionReference<Map<String, dynamic>> collectionUsers =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> docUser =
        collectionUsers.doc(userUid);

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
        _db.collection(rootUsersCollection);

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

  // update room preferences
  Future addRoomPreferences(
      DocumentReference<Map<String, dynamic>> roomReference,
      model.User oldUser) async {
    model.User newUser = model.User.copy(oldUser);

    newUser.roomReferences.add(roomReference);

    await updateUser(oldUser, newUser);
  }

  // update user
  Future updateUser(model.User oldUser, model.User newUser) async {
    // collection
    final collection = _db.collection(rootUsersCollection);

    final doc = collection.doc(oldUser.uid);

    // update user
    await doc.update(newUser.toMap());
  }

  // stream user
  Stream<model.User> streamUser(model.User user) {
    final CollectionReference<Map<String, dynamic>> collection =
        _db.collection(rootUsersCollection);

    final DocumentReference<Map<String, dynamic>> doc =
        collection.doc(user.uid);

    final Stream<model.User> snapshot =
        doc.snapshots().map((snap) => model.User.fromMap(snap.data()!));

    return snapshot;
  }
}
