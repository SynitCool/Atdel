// flutter
import 'package:atdel/src/host_room_control_pages/home_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databases/firebase_firestore.dart';
import 'package:flutter/material.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

// html
import 'package:flutter_html/flutter_html.dart';

class JoinRoomPreviewPage extends StatefulWidget {
  const JoinRoomPreviewPage({Key? key, required this.reference})
      : super(key: key);

  final DocumentReference<Map<String, dynamic>> reference;

  @override
  State<JoinRoomPreviewPage> createState() => _JoinRoomPreviewPageState();
}

class _JoinRoomPreviewPageState extends State<JoinRoomPreviewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ViewHtml(reference: widget.reference));
  }
}

class ViewHtml extends StatefulWidget {
  const ViewHtml({Key? key, required this.reference}) : super(key: key);

  final DocumentReference<Map<String, dynamic>> reference;

  @override
  State<ViewHtml> createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  Widget showHtmlWidget(String htmlData) {
    return SingleChildScrollView(child: Html(data: htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: widget.reference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final DocumentSnapshot<Map<String, dynamic>>? doc = snapshot.data;
        final Map<String, dynamic>? data = doc!.data();
        final Map<String, dynamic> infoRoom = data!["info_room"];

        return showHtmlWidget(infoRoom["room_desc"]);
      },
    );
  }
}
