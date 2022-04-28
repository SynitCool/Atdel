class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Take The Attendance Easily",
    image: "assets/images/image1.png",
    desc: "Atdel will help you to take attendance easily and organize.",
  ),
  OnboardingContents(
    title: "Organizing Attendances With Atdel is Easy",
    image: "assets/images/image2.png",
    desc:
        "Organizing your attendances with atdel is easy.",
  ),
  OnboardingContents(
    title: "Managing Attendances With Atdel To Other Platform",
    image: "assets/images/image3.png",
    desc:
        "Atdel can be great to deal with other platform to managing attendances.",
  ),
];