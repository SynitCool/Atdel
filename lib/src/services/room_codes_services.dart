// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:atdel/src/model/room.dart';

class RoomCodesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String rootCodesCollection = "codes";
  final String rootRoomsCollection = "rooms";
  final String docRoomCodes = "room_codes";

  // add room codes
  Future addRoomCodes(Map<String, dynamic> codeMap) async {
    // room codes doc
    final collection = _db.collection(rootCodesCollection);

    final doc = collection.doc(docRoomCodes);

    // update room codes
    final DocumentSnapshot<Map<String, dynamic>> getCodes = await doc.get();

    final Map<String, dynamic>? codesMap = getCodes.data();

    codesMap!.addAll({codeMap["room_code"]: codeMap["room_reference"]});

    await doc.update(codesMap);
  }

  // get room code
  Future getRoomByCode(String code) async {
    // room codes doc
    final CollectionReference<Map<String, dynamic>> roomCodesCollection =
        _db.collection(rootCodesCollection);

    final DocumentReference<Map<String, dynamic>> codesDoc =
        roomCodesCollection.doc(docRoomCodes);

    // get reference with code
    final DocumentSnapshot<Map<String, dynamic>> getRoomCodesDoc =
        await codesDoc.get();

    final Map<String, dynamic> roomCodesMap = getRoomCodesDoc.data()!;

    // check code is valid
    if (!roomCodesMap.containsKey(code)) return "code_not_valid";

    return Room.fromFirestore(await roomCodesMap[code].get());
  }


  // delete room code
  Future deleteRoomCode(Room room) async {
    // room codes collection
    final CollectionReference<Map<String, dynamic>> roomCodesCollection =
        _db.collection(rootCodesCollection);

    final DocumentReference<Map<String, dynamic>> roomCodesDoc =
        roomCodesCollection.doc(docRoomCodes);

    // delete room code
    final DocumentSnapshot<Map<String, dynamic>> getRoomCodes =
        await roomCodesDoc.get();

    final Map<String, dynamic>? roomCodesMap = getRoomCodes.data();

    roomCodesMap!.remove(room.roomCode);

    await roomCodesDoc.set(roomCodesMap);
  }
}
