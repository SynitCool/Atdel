// flutter
import 'package:flutter/material.dart';

// logo
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// authentication
import 'package:atdel/src/authentication/google_authentication.dart';

// pages
import 'package:atdel/src/initialize_pages/initialize_pages.dart';

// custom widgets
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  final Color color = const Color(0xffD94928);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      const Image(
                          image: AssetImage("assets/images/menuimage.png")),
                      Column(
                        children: const [
                          Text(
                            "Hey there, Welcome back!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Login to your account to continue",
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.black54,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(8.0)),
                    onPressed: () async {
                      SmartDialog.showLoading();

                      final provider = GoogleSignInProvider();

                      final user = await provider.googleLogin();

                      SmartDialog.dismiss();

                      if (user == null) return;

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InitializePages()));
                    },
                    label: Text(
                      "Sign up with Google",
                      style: TextStyle(color: color, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'By tapping Sign up, you agree to our '),
                      TextSpan(
                          text: 'Privacy Policies',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
