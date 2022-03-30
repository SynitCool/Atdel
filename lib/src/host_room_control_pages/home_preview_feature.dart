// flutter
import 'package:atdel/src/host_room_control_pages/home_feature.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// custom widget
import 'package:floating_action_bubble/floating_action_bubble.dart';

// html
import 'package:flutter_html/flutter_html.dart';

class HomePreviewPage extends StatefulWidget {
  const HomePreviewPage({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<HomePreviewPage> createState() => _HomePreviewPageState();
}

class _HomePreviewPageState extends State<HomePreviewPage>
    with SingleTickerProviderStateMixin {
  // animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  Bubble editButton() {
    return Bubble(
        icon: Icons.edit,
        iconColor: Colors.white,
        title: "Edit",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        roomId: widget.roomId,
                      )));
        });
  }

  FloatingActionBubble scaffoldFloatingActionButton() {
    return FloatingActionBubble(
        items: [editButton()],
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        backGroundColor: Colors.blue,
        animation: _animation,
        iconData: Icons.menu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: scaffoldFloatingActionButton(),
        body: ViewHtml(currentRoomId: widget.roomId));
  }
}

class ViewHtml extends StatefulWidget {
  const ViewHtml({Key? key, required this.currentRoomId}) : super(key: key);

  final String currentRoomId;

  @override
  State<ViewHtml> createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  // firebase auth
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  late String firebaseUserUid;

  // firebase firestore
  late String collectionPath;
  late CollectionReference<Map<String, dynamic>> collection;
  late DocumentReference<Map<String, dynamic>> docCollection;

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  @override
  void initState() {
    super.initState();
    
    // firebase auth
    firebaseUserUid = firebaseUser!.uid;

    // firebase firestore
    collectionPath = "users/$firebaseUserUid/rooms";
    collection = FirebaseFirestore.instance.collection(collectionPath);
    docCollection = collection.doc(widget.currentRoomId);
  }

  Future<String> getRoomInfo() async {
    // get data databases
    final DocumentSnapshot<Map<String, dynamic>> getDocCollection =
        await docCollection.get();
    final Map<String, dynamic>? getDocColectionData = getDocCollection.data();

    final Map<String, dynamic> roomInfo = getDocColectionData!["info_room"];

    return roomInfo["room_desc"];
  }

  Widget showHtmlWidget(String htmlData) {
    return SingleChildScrollView(child: Html(data: htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getRoomInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScene;
          }

          if (snapshot.hasError) return errorScene;

          final roomDesc = snapshot.data;

          return showHtmlWidget(roomDesc!);
        });
  }
}
