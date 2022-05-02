// flutter
import 'package:flutter/material.dart';

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';

// join room title
class JoinRoomTitle extends StatelessWidget {
  const JoinRoomTitle({Key? key, required this.title, required this.width})
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

// join room desc
class JoinRoomDesc extends StatelessWidget {
  const JoinRoomDesc({Key? key, required this.desc, required this.width})
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

// join room back button
class JoinRoomBackButton extends StatelessWidget {
  const JoinRoomBackButton(
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

// join room next button
class JoinRoomNextButton extends StatelessWidget {
  const JoinRoomNextButton(
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

// room code text field
class RoomCodeTextField extends StatefulWidget {
  const RoomCodeTextField(
      {Key? key, required this.callback, required this.controller})
      : super(key: key);

  final Function callback;
  final TextEditingController controller;

  @override
  State<RoomCodeTextField> createState() => _RoomCodeTextFieldState();
}

class _RoomCodeTextFieldState extends State<RoomCodeTextField> {
  // name text controller
  final TextEditingController nameTextFieldController = TextEditingController();
  String nameText = '';

  @override
  void initState() {
    super.initState();

    nameText = widget.controller.text;
    widget.callback(nameText);
  }

  // erroe text
  String? get errorText {
    final String codeRoomText = widget.controller.value.text;

    if (codeRoomText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (codeRoomText.length == 6) return null;

    return 'The room id must be 6 characters';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          label: const Text("Room Code"),
          border: const OutlineInputBorder(),
          errorText: errorText),
      onChanged: (text) => setState(() {
        nameText = text;
        widget.callback(nameText);
      }),
    );
  }
}

// user alias text field
class UserAliasTextField extends StatefulWidget {
  const UserAliasTextField(
      {Key? key, required this.callback, required this.controller})
      : super(key: key);

  final Function callback;
  final TextEditingController controller;

  @override
  State<UserAliasTextField> createState() => _UserAliasTextFieldState();
}

class _UserAliasTextFieldState extends State<UserAliasTextField> {
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
          label: const Text("User alias"),
          border: const OutlineInputBorder(),
          errorText: errorText),
      onChanged: (text) => setState(() {
        nameText = text;
        widget.callback(nameText);
      }),
    );
  }
}

// show not valid code
Future showNotValidCode(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        "ERROR",
        style: TextStyle(color: Colors.red),
      ),
      content: const Text("The code is not valid. Get the code from the host!"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// show user is not include
Future showUserNotInclude(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        "ERROR",
        style: TextStyle(color: Colors.red),
      ),
      content: const Text(
          "You're not include in this room. Ask the host to add you!"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// check room code is valid
bool roomCodeValid(String roomCode) {
  if (roomCode.isEmpty) {
    toastWidget("Room Code Supposed Not To Be Empty!");
    return false;
  }
  if (roomCode.length != 6) {
    toastWidget("Room Code Supposed To Be 6 Characters!");
    return false;
  }

  return true;
}

// join room status
bool joinRoomStatusValid(String status) {
  if (status == "code_not_valid") {
    toastWidget("The code is not valid. Get the code from the host!");
    return false;
  }
  if (status == "user_not_include") {
    toastWidget("You're not include in this room. Ask the host to add you!");
    return false;
  }

  return true;
}
