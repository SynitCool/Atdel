// flutter
import 'package:flutter/material.dart';

// launcher
import 'package:url_launcher/url_launcher.dart';

// icons
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// widgets
import 'package:atdel/src/main_pages/home_settings/widgets/credits_pages.dart';

// page
class CreditsPage extends StatelessWidget {
  const CreditsPage({Key? key}) : super(key: key);

  PreferredSizeWidget scaffoldAppBar() => AppBar(
        title: const Text("Credits"),
        centerTitle: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: scaffoldAppBar(), body: const ContentPage());
  }
}

// content
class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const CreditsTitle(),
          const CreditsContent(credits: credits),
          const SizedBox(height: 20),
          const FindUsTitle(),
          ...socialMedia.map((data) => LogoButton(
              icon: data["icon"],
              text: data["title"],
              onPressed: () async {
                final Uri _url = Uri.parse(data["link"]);

                if (!await launchUrl(_url)) throw 'Could not launch $_url';
              }))
        ],
      ),
    );
  }
}

// social media
const List<Map<String, dynamic>> socialMedia = [
  {
    "icon": FontAwesomeIcons.github,
    "link": "https://github.com/SynitCool",
    "title": "GitHub"
  },
  {
    "icon": FontAwesomeIcons.twitter,
    "link": "https://twitter.com/SynitIsCool",
    "title": "Twitter"
  },
  {
    "icon": FontAwesomeIcons.dribbble,
    "link": "https://synitcool.github.io/Atdel/",
    "title": "Website"
  },
];

// credits
const List<Map<String, dynamic>> credits = [
  {"theme": "Template", "credit": "FlutterAwesome"},
  {"theme": "Flutter", "credit": "Google"},
  {"theme": "Thied Party Library", "credit": "Pub Dart"},
];
