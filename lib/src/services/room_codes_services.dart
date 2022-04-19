// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCodesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootCodesCollection = "codes";
  final String docRoomCodes = "room_codes";

  // add room codes
  Future addRoomCodes(
      Map<String, dynamic> codeMap) async {
    // room codes doc
    final collection = _db.collection(rootCodesCollection);

    final doc = collection.doc(docRoomCodes);

    // update room codes
    final DocumentSnapshot<Map<String, dynamic>> getCodes =
        await doc.get();

    final Map<String, dynamic>? codesMap = getCodes.data();

    codesMap!.addAll({codeMap["room_code"]: codeMap["room_reference"]});

    await doc.update(codesMap);
  }
}
