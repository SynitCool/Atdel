import 'package:flutter/material.dart';


class DrawerWidget extends StatefulWidget {
  final List<dynamic> usersData;

  const DrawerWidget({Key? key, required this.usersData}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // drawer host room
  Widget materialHeader(BuildContext context, Map<String, dynamic> hostInfo) {
    // host profile
    final String urlImage = hostInfo["user_image_url"];
    final String name = hostInfo["user_name"];
    final String email = hostInfo["user_email"];

    const padding = EdgeInsets.symmetric(horizontal: 20);
    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage));
    const SizedBox spaceWidth20 = SizedBox(width: 20);
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.home,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            name,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        email,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ]);

    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              avatarPicture,
              spaceWidth20,
              avatarInfoWidget,
            ],
          )),
    );
  }

  // drawer member room
  Widget materialContentButton(
      BuildContext context, Map<String, dynamic> memberInfo) {
    // host profile
    final String urlImage = memberInfo["user_image_url"];
    final String name = memberInfo["user_name"];
    final String email = memberInfo["user_email"];

    final CircleAvatar avatarPicture =
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage));
    const SizedBox spaceWidth4 = SizedBox(width: 4);
    const SizedBox spaceHeight4 = SizedBox(height: 4);

    Widget avatarInfoWidget =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          spaceWidth4,
          Text(
            name,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
      spaceHeight4,
      Text(
        email,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ]);

    return ListTile(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => UserPage(user!)));
      },
      leading: avatarPicture,
      title: avatarInfoWidget,
    );
  }

  // drawer content
  Widget materialDrawer() {
    // widget parameters
    const Widget space12 = SizedBox(height: 12);
    const Widget space24 = SizedBox(height: 24);
    // const Widget space16 = SizedBox(height: 16);
    const Widget divider70 = Divider(color: Colors.white70);
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);
    const Widget memberTitle = Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Members",
        style: TextStyle(
            color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );

    // user type
    late Map<String, dynamic> hostUser;
    List<dynamic> membersUser = [];

    // separate member and host
    for (int i = 0; i < widget.usersData.length; i++) {
      Map<String, dynamic> currentUser = widget.usersData[i];
      String userType = currentUser["type"];

      if (userType == "Host") {
        hostUser = currentUser;
      } else {
        membersUser.add(currentUser);
      }
    }

    // content button widgets
    List<Widget> materialDrawerButtons = [
      space12,
      divider70,
      memberTitle,
      space24,
    ];

    // adding member button
    for (int i = 0; i < membersUser.length; i++) {
      Map<String, dynamic> currentMember = membersUser[i];

      materialDrawerButtons.add(materialContentButton(context, currentMember));
    }

    // content drawer widgets
    List<Widget> materialDrawerWidget = [
      materialHeader(context, hostUser),
      Container(
        padding: padding,
        child: Column(
          children: materialDrawerButtons,
        ),
      ),
    ];

    // the background widget
    return ListView(
      children: materialDrawerWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return materialDrawer();
  }
}
