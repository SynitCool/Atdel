// dart
import 'dart:io';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/selected_users.dart';
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/storage_services.dart';
import 'package:atdel/src/services/user_photo_metrics_services.dart';

class SelectedUsersServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootRoomsCollection = "rooms";

  // get selected users
  Future<List<SelectedUsers>> getSelectedUsers(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> selectedUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/selected_users");

    // get selected users
    final getSelectedUsers = await selectedUsersCollection.get();

    final selectedUsersInObject = getSelectedUsers.docs
        .map((data) => SelectedUsers.fromFireStore(data))
        .toList();

    return selectedUsersInObject;
  }

  // deleate all selected users
  Future deleteSelectedUsers(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> selectedUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/selected_users");

    // delete all attendance list
    selectedUsersCollection.get().then((snapshot) {
      for (final snap in snapshot.docs) {
        snap.reference.delete();
      }
    });
  }

  // check selected users
  Future<SelectedUsers?> getSelectedUsersByEmail(
      Room room, String email) async {
    // collection
    final collection =
        _db.collection("$rootRoomsCollection/${room.id}/selected_users");

    final doc = collection.doc(email);

    // check doc
    final getDoc = await doc.get();

    if (!getDoc.exists) return null;

    return SelectedUsers.fromFireStore(getDoc);
  }

  // add selected users to database
  Future addSelectedUsers(
      Room room, List<Map<String, dynamic>> selectedUsers) async {
    final StorageService _storageService = StorageService();

    // collection
    final collectionPath = "$rootRoomsCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    // make doc and set
    for (final selectedUser in selectedUsers) {
      if (selectedUser["photo_file"] != null) {
        // upload photo user
        final photoUrl = await _storageService.uploadSelectedUsersPhoto(
            room, File(selectedUser["photo_file"].path), selectedUser["alias"]);

        selectedUser["photo_url"] = photoUrl;
      }

      selectedUser.remove("photo_file");

      final selected = SelectedUsers.fromMap(selectedUser);

      final doc = collection.doc(selected.email);

      await doc.set(selected.toMap());
    }
  }

  // remove selected users
  Future removeSelectedUsers(Room room, SelectedUsers selectedUsers) async {
    final StorageService _storageService = StorageService();
    final UserPhotoMetricService _userPhotoMetricService =
        UserPhotoMetricService();

    // collection
    final collectionPath = "$rootRoomsCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(selectedUsers.email);

    // delete selected users photo if exist
    await _storageService.deleteSelectedUsersPhoto(room, selectedUsers);

    // delete user photo metric
    await _userPhotoMetricService.deleteUserPhotoMetric(room, selectedUsers);

    // remove selected user
    await doc.delete();
  }

  // update selected user
  Future updateSelectedUser(Room room, SelectedUsers oldSelectedUsers,
      SelectedUsers newSelectedUsers) async {
    // collection
    final collectionPath = "$rootRoomsCollection/${room.id}/selected_users";

    final collection = _db.collection(collectionPath);

    final doc = collection.doc(oldSelectedUsers.email);

    // update
    await doc.update(newSelectedUsers.toMap());
  }

  // check selected users exist
  Future<bool> checkSelectedUsersExist(Room room) async {
    // collection
    final CollectionReference<Map<String, dynamic>> selectedUsersCollection =
        _db.collection("$rootRoomsCollection/${room.id}/selected_users");

    // get collection and check
    final getCollection = await selectedUsersCollection.get();

    if (getCollection.docs.isEmpty) return false;

    return true;
  }

  // stream selected users
  Stream<List<SelectedUsers>> streamSelectedUsers(Room room) {
    final collection =
        _db.collection("$rootRoomsCollection/${room.id}/selected_users");

    final stream = collection.snapshots().map((data) =>
        data.docs.map((data) => SelectedUsers.fromMap(data.data())).toList());

    return stream;
  }
}
