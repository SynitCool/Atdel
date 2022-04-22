// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/host_room_pages/private_room_control/widgets/private_room.dart';

// private room
class PrivateRoom extends StatefulWidget {
  const PrivateRoom({Key? key}) : super(key: key);

  @override
  State<PrivateRoom> createState() => _PrivateRoomState();
}

class _PrivateRoomState extends State<PrivateRoom> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ContentRoom());
  }
}

// content room
class ContentRoom extends StatefulWidget {
  const ContentRoom({ Key? key }) : super(key: key);

  @override
  State<ContentRoom> createState() => _ContentRoomState();
}

class _ContentRoomState extends State<ContentRoom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          PrivateRoomContent(),
          SizedBox(height: 50),
          PrivatePicturesContent()],
      ),
    );
  }
}


// private room content
class PrivateRoomContent extends StatefulWidget {
  const PrivateRoomContent({ Key? key }) : super(key: key);

  @override
  State<PrivateRoomContent> createState() => _PrivateRoomContentState();
}

class _PrivateRoomContentState extends State<PrivateRoomContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SelectedUsersTitle(),
          ShowSelectedUsersButton(),
          AddSelectedUsersButton(),
          SelectedUsersFileButton(),],
      );
  }
}

// private pictures content
class PrivatePicturesContent extends StatefulWidget {
  const PrivatePicturesContent({ Key? key }) : super(key: key);

  @override
  State<PrivatePicturesContent> createState() => _PrivatePicturesContentState();
}

class _PrivatePicturesContentState extends State<PrivatePicturesContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SelectedUsersMlTitle(),
        ShowSelectedUsersPicturesMlButton(),
        AddSelectedUsersPicturesMlButton(),
        SelectedUsersPicturesMlFileButton(),
      ]
    );
  }
}