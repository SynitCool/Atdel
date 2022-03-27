import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  // google login
  Future googleLogin() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    await addUserDatabase();
  }

  // google logout
  Future googleLogout() async {
    // await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  // add user in database
  Future addUserDatabase() async {
    // user
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    // user profile
    final String firebaseUserUid = firebaseUser!.uid;
    final String? firebaseUserDisplayName = firebaseUser.displayName;
    final String? firebaseUserEmail = firebaseUser.email;
    final String? firebaseUserPhotoUrl = firebaseUser.photoURL;
    final bool firebaseUserIsAnonymous = firebaseUser.isAnonymous;

    final Map<String, dynamic> firebaseUserInfo = {
      "uid": firebaseUserUid,
      "diplay_name": firebaseUserDisplayName,
      "email": firebaseUserEmail,
      "photo_url": firebaseUserPhotoUrl,
      "is_anonymous": firebaseUserIsAnonymous
    };

    await checkAccount(uid: firebaseUserUid, userJson: firebaseUserInfo);
  }

  Future checkAccount({required String uid, required Map<String, dynamic> userJson}) async {
    final CollectionReference<Map<String, dynamic>> userCollection =
        FirebaseFirestore.instance.collection("users");

    // check the uid is exist
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await userCollection.doc(uid).get();
    final bool docExists = doc.exists;

    if (!docExists) await userCollection.doc(uid).set(userJson);
  }
}
