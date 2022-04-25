// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/main_pages/join_room/widgets/join_room_page.dart';

// util
import 'package:atdel/src/main_pages/join_room/size_config.dart';
import 'package:atdel/src/main_pages/join_room/join_room_contents.dart';

// join room on boarding
class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  // form
  String roomCode = '';
  String userAlias = '';

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
  final TextEditingController userAliasController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widgets.add(roomCodePage());
    widgets.add(userAliasPage());
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

  // user alias page
  Widget userAliasPage() => Center(
      child: UserAliasTextField(
          callback: (value) {
            setState(() {
              userAlias = value;
            });
          },
          controller: userAliasController));

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
                            JoinRoomButton(
                                roomCode: roomCode,
                                userAlias: userAlias,
                                width: width),
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
