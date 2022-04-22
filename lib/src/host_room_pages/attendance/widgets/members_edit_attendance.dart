// flutter
import 'package:flutter/material.dart';


// column tile
class ColumnTile extends StatelessWidget {
  const ColumnTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          const CircleAvatar(backgroundColor: Colors.transparent, radius: 30),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Expanded(
                child: Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            VerticalDivider(),
            Expanded(
                child: Text("Email",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            VerticalDivider(),
            Expanded(
                child: Text("Absent",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
    );
  }
}
