// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/selected_users.dart';
import 'package:atdel/src/model/room.dart';

class SelectedUsersServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomCollection = "rooms";

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

  // stream selected users
  Stream<List<SelectedUsers>> streamSelectedUsers(Room room) {
    final collection =
        _db.collection("$rootRoomCollection/${room.id}/selected_users");

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => SelectedUsers.fromMap(data.data())).toList());

    return stream;
  }
}
