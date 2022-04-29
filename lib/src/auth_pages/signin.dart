// flutter
import 'package:flutter/material.dart';

// logo
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// authentication
import 'package:atdel/src/authentication/google_authentication.dart';

// pages
import 'package:atdel/src/initialize_pages/initialize_pages.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  // PreferredSizeWidget appBarWidget() =>
  //     AppBar(title: const Text("Sign in"), centerTitle: true);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: appBarWidget(),
  //     body: Center(
  //         child: Padding(
  //             padding: const EdgeInsets.all(32),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 ElevatedButton.icon(
  //                   onPressed: () {
  //                     final provider = GoogleSignInProvider();

  //                     provider.googleLogin();
  //                   },
  //                   icon: const FaIcon(FontAwesomeIcons.google),
  //                   label: const Text("Sign in with google"),
  //                   style: ElevatedButton.styleFrom(
  //                       primary: Colors.white,
  //                       onPrimary: Colors.black,
  //                       minimumSize: const Size(double.infinity, 50)),
  //                 )
  //               ],
  //             ))),
  //   );
  // }

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
                      final provider = GoogleSignInProvider();

                      final user = await provider.googleLogin();

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
