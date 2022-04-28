class CreateRoomContents {
  final String title;
  final String desc;

  CreateRoomContents({required this.title, required this.desc});
}

List<CreateRoomContents> contents = [
  CreateRoomContents(
    title: "Join Room With Code And Take Attendance With Atdel.",
    desc: "Type room code to join room, get the room code by the host.",
  )
];
