class CreateRoomContents {
  final String title;
  final String desc;

  CreateRoomContents({required this.title, required this.desc});
}

List<CreateRoomContents> contents = [
  CreateRoomContents(
    title: "Join Room With Code And Take Attendance With Atdel.",
    desc: "Type room code to join room, get the room code by the host.",
  ),
  CreateRoomContents(
      title: "The Room Is Public",
      desc:
          "The room is public, specify user alias for the room for the others can recognize you."),
];
