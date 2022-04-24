// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/selected_users.dart';
import 'package:atdel/src/model/room.dart';
import 'package:atdel/src/model/user.dart';

class SelectedUsersServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomCollection = "rooms";

  // check selected users
  Future<SelectedUsers?> getSelectedUsersByEmail(Room room, User user) async {
    // collection
    final collection =
        _db.collection("$rootRoomCollection/${room.id}/selected_users");

    final doc = collection.doc(user.email);

    // check doc
    final getDoc = await doc.get();

    if (!getDoc.exists) return null;

    return SelectedUsers.fromFireStore(getDoc);
  }

  // add selected users to database
  Future addSelectedUsers(
      Room room, List<Map<String, dynamic>> selectedUsers) async {
    // collection
    final collectionPath = "$rootRoomCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    // make doc and set
    for (final selectedUser in selectedUsers) {
      final doc = collection.doc(selectedUser["email"]);

      await doc.set(selectedUser);
    }
  }

  // remove selected users
  Future removeSelectedUsers(Room room, SelectedUsers selectedUsers) async {
    // collection
    final collectionPath = "$rootRoomCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(selectedUsers.email);

    // remove selected user
    await doc.delete();
  }

  // update selected user
  Future updateSelectedUser(Room room, SelectedUsers oldSelectedUsers,
      SelectedUsers newSelectedUsers) async {
    // collection
    final collectionPath = "$rootRoomCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(oldSelectedUsers.email);

    // update
    await doc.update(newSelectedUsers.toMap());
  }

  // stream selected users
  Stream<List<SelectedUsers>> streamSelectedUsers(Room room) {
    final collection =
        _db.collection("$rootRoomCollection/${room.id}/selected_users");

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => SelectedUsers.fromMap(data.data())).toList());

    return stream;
  }
}
