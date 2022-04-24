class CreateRoomContents {
  final String title;
  final String desc;

  CreateRoomContents({required this.title, required this.desc});
}

List<CreateRoomContents> contents = [
  CreateRoomContents(
    title: "Create Room To Take Attendance Easily with Atdel.",
    desc: "Remember to make the name of room simple.",
  ),
  CreateRoomContents(
    title: "Choose What Type The Room Would Be",
    desc: "The options can be changed after creating the room."
  ),
  CreateRoomContents(
    title: "Let The Members of The Room Know",
    desc:
        "Make your alias to be easily recognized by others and make it simple."
  ),
];
