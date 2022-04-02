// flutter
import 'package:flutter/material.dart';

// html
import 'package:flutter_html/flutter_html.dart';

// model
import 'package:atdel/src/model/room.dart';

// services
import 'package:atdel/src/services/room_services.dart';

class JoinRoomPreviewPage extends StatefulWidget {
  const JoinRoomPreviewPage({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<JoinRoomPreviewPage> createState() => _JoinRoomPreviewPageState();
}

class _JoinRoomPreviewPageState extends State<JoinRoomPreviewPage>
    with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ViewHtml(room: widget.room));
  }
}

class ViewHtml extends StatefulWidget {
  const ViewHtml({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<ViewHtml> createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("Something went wrong!"));

  // services
  final RoomService _roomService = RoomService();

  Widget showHtmlWidget(String htmlData) {
    return SingleChildScrollView(child: Html(data: htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Room>(
      stream: _roomService.streamGetRoomInfo(widget.room.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        return showHtmlWidget(data!.roomDesc);
      },
    );
  }
}
