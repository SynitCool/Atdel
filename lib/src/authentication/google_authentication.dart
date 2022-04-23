// firebase
import 'package:firebase_auth/firebase_auth.dart';

// google
import 'package:google_sign_in/google_sign_in.dart';

// model
import 'package:atdel/src/model/user.dart' as model;

// services
import 'package:atdel/src/services/user_services.dart';

class GoogleSignInProvider {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  // google login
  Future googleLogin() async {
    // google log in
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    final model.User modelUser = model.User.fromFirebaseAuth(firebaseUser!);

    final UserService service = UserService();

    service.addUserToDatabase(modelUser);
  }

  // google logout
  Future googleLogout() async {
    // await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
