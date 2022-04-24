// flutter
import 'package:flutter/material.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// create room title
class CreateRoomTitle extends StatelessWidget {
  const CreateRoomTitle({Key? key, required this.title, required this.width})
      : super(key: key);

  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Mulish",
        fontWeight: FontWeight.w600,
        fontSize: (width <= 550) ? 30 : 35,
      ),
    );
  }
}

// create room desc
class CreateRoomDesc extends StatelessWidget {
  const CreateRoomDesc({Key? key, required this.desc, required this.width})
      : super(key: key);

  final String desc;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      desc,
      style: TextStyle(
        fontFamily: "Mulish",
        fontWeight: FontWeight.w300,
        fontSize: (width <= 550) ? 17 : 25,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// create room back button
class CreateRoomBackButton extends StatelessWidget {
  const CreateRoomBackButton(
      {Key? key, required this.onPressed, required this.width})
      : super(key: key);

  final Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "BACK",
        style: TextStyle(color: Colors.black),
      ),
      style: TextButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: (width <= 550) ? 13 : 17,
        ),
      ),
    );
  }
}

// create room next button
class CreateRoomNextButton extends StatelessWidget {
  const CreateRoomNextButton(
      {Key? key, required this.onPressed, required this.width})
      : super(key: key);

  final Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text("NEXT"),
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        padding: (width <= 550)
            ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
      ),
    );
  }
}

// room name text field
class RoomNameTextField extends StatefulWidget {
  const RoomNameTextField(
      {Key? key, required this.callback, required this.controller})
      : super(key: key);

  final Function callback;
  final TextEditingController controller;

  @override
  State<RoomNameTextField> createState() => _RoomNameTextFieldState();
}

class _RoomNameTextFieldState extends State<RoomNameTextField> {
  // name text controller
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  @override
  void initState() {
    super.initState();

    nameText = widget.controller.text;
    widget.callback(nameText);
  }

  // error text field
  String? get errorText {
    final String text = widget.controller.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          label: const Text("Room name"),
          border: const OutlineInputBorder(),
          errorText: errorText),
      onChanged: (text) => setState(() {
        nameText = text;
        widget.callback(nameText);
      }),
    );
  }
}

// private room check box
class PrivateRoomCheckbox extends StatefulWidget {
  const PrivateRoomCheckbox(
      {Key? key, required this.callback, required this.callbackPrivateRoom})
      : super(key: key);

  final Function callback;
  final Function callbackPrivateRoom;

  @override
  State<PrivateRoomCheckbox> createState() => _PrivateRoomCheckboxState();
}

class _PrivateRoomCheckboxState extends State<PrivateRoomCheckbox> {
  late bool privateRoom;

  @override
  void initState() {
    super.initState();

    privateRoom = widget.callbackPrivateRoom();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        shape: const OutlineInputBorder(),
        value: privateRoom,
        title: const Text("Make as Private"),
        subtitle: const Text("The host can specify who can enter the room"),
        onChanged: (value) {
          setState(() {
            privateRoom = value!;

            widget.callback(privateRoom);
          });
        });
  }
}

// attendance with ml check box
class AttendanceWithMlCheckbox extends StatefulWidget {
  const AttendanceWithMlCheckbox(
      {Key? key,
      required this.callback,
      required this.callbackAttendanceWithMl})
      : super(key: key);

  final Function callback;
  final Function callbackAttendanceWithMl;

  @override
  State<AttendanceWithMlCheckbox> createState() =>
      _AttendanceWithMlCheckboxState();
}

class _AttendanceWithMlCheckboxState extends State<AttendanceWithMlCheckbox> {
  late bool attendanceWithMl;

  @override
  void initState() {
    super.initState();

    attendanceWithMl = widget.callbackAttendanceWithMl();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        shape: const OutlineInputBorder(),
        value: attendanceWithMl,
        title: const Text("Attendance With ML"),
        subtitle: const Text("Take attendance with machine learning."),
        onChanged: (value) {
          setState(() {
            attendanceWithMl = value!;

            widget.callback(attendanceWithMl);
          });
        });
  }
}

// host alias text field
class HostAliasTextField extends StatefulWidget {
  const HostAliasTextField(
      {Key? key, required this.callback, required this.controller})
      : super(key: key);

  final Function callback;
  final TextEditingController controller;

  @override
  State<HostAliasTextField> createState() => _HostAliasTextFieldState();
}

class _HostAliasTextFieldState extends State<HostAliasTextField> {
  // name text controller
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  @override
  void initState() {
    super.initState();

    nameText = widget.controller.text;
    // widget.callback(nameText);
  }

  // error text field
  String? get errorText {
    final String text = widget.controller.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    } else if (text.length < 4) {
      return 'Too short';
    } else if (text.length > 12) {
      return 'Too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          label: const Text("Host alias"),
          border: const OutlineInputBorder(),
          errorText: errorText),
      onChanged: (text) => setState(() {
        nameText = text;
        widget.callback(nameText);
      }),
    );
  }
}

// create room button
class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({
    Key? key,
    required this.roomInfo,
    required this.hostAlias,
    required this.width,
  }) : super(key: key);

  final String hostAlias;
  final Map<String, dynamic> roomInfo;
  final double width;

  @override
  Widget build(BuildContext context) {
    final RoomService roomService = RoomService();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            if (roomInfo["room_name"].isEmpty ||
                roomInfo["room_name"].length < 4) return;
            if (roomInfo["room_name"].length > 12) return;

            roomService.addRoomToDatabase(roomInfo, hostAlias);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          child: const Text("Create"),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
            padding: (width <= 550)
                ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
          ),
        ));
  }
}
