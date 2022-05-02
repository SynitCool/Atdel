// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/main_pages/join_room/widgets/join_room_page.dart';

// services
import 'package:atdel/src/services/room_services.dart';

// pages
import 'package:atdel/src/main_pages/home_pages.dart';

// util
import 'package:atdel/src/main_pages/join_room/size_config.dart';
import 'package:atdel/src/main_pages/join_room/join_room_contents.dart';

// custom widgets
import 'package:atdel/src/widgets/dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// join room on boarding
class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  // form
  String roomCode = '';

  // page view
  final _controller = PageController();
  int _currentPage = 0;
  List colors = const [Color(0xffDAD3C8), Color(0xffFFE5DE)];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  // widgets
  List<Widget> widgets = [];

  // controller
  final TextEditingController roomCodeController = TextEditingController();

  // services
  final RoomService _roomService = RoomService();

  // size
  double width = 0.0;

  @override
  void initState() {
    super.initState();

    widgets.add(roomCodePage());
  }

  // room name page
  Widget roomCodePage() => Center(
        child: RoomCodeTextField(
          callback: (value) {
            roomCode = value;
          },
          controller: roomCodeController,
        ),
      );

  Widget joinRoomButton() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          if (!roomCodeValid(roomCode)) return;

          SmartDialog.showLoading();

          final status = await _roomService.joinRoomWithCode(roomCode);

          SmartDialog.dismiss();

          if (!joinRoomStatusValid(status)) return;

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: const Text("Join"),
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          JoinRoomTitle(title: contents[i].title, width: width),
                          const SizedBox(
                            height: 15,
                          ),
                          JoinRoomDesc(desc: contents[i].desc, width: width),
                          const SizedBox(
                            height: 30,
                          ),
                          widgets[i]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    contents.length,
                    (int index) => _buildDots(index: index),
                  ),
                ),
                _currentPage + 1 == contents.length
                    ? Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            joinRoomButton(),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            JoinRoomBackButton(
                                onPressed: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                  FocusScope.of(context).unfocus();
                                },
                                width: width),
                            JoinRoomNextButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );

                                  FocusScope.of(context).unfocus();
                                },
                                width: width)
                          ],
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
