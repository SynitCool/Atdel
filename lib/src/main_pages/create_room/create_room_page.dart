// flutter
import 'package:flutter/material.dart';

// widgets
import 'package:atdel/src/main_pages/create_room/widgets/create_room_page.dart';

// util
import 'package:atdel/src/main_pages/create_room/size_config.dart';
import 'package:atdel/src/main_pages/create_room/create_room_contents.dart';

// create room on boarding
class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  // form
  String roomName = '';
  bool privateRoom = false;
  bool attendanceWithMl = false;
  String hostAlias = '';

  // page view
  final _controller = PageController();
  int _currentPage = 0;
  List colors = const [Color(0xffDAD3C8), Color(0xffFFE5DE), Color(0xffDCF6E6)];

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
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController hostAliasController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widgets.add(roomNamePage());
    widgets.add(optionsPage());
    widgets.add(hostAliasPage());
  }

  // room name page
  Widget roomNamePage() => Center(
        child: RoomNameTextField(
          callback: (value) {
            roomName = value;
          },
          controller: roomNameController,
        ),
      );

  // options page
  Widget optionsPage() => Column(
        children: [
          privateRoomCheckbox(),
          const SizedBox(height: 15),
          attendanceWithMlCheckbox()
        ],
      );

  // private room checkbox
  Widget privateRoomCheckbox() => PrivateRoomCheckbox(
        callback: (value) {
          setState(() {
            privateRoom = value;
          });
        },
        callbackPrivateRoom: () => privateRoom,
      );

  // attendance with ml checbox
  Widget attendanceWithMlCheckbox() => AttendanceWithMlCheckbox(
      callback: (value) {
        setState(() {
          attendanceWithMl = value;
        });
      },
      callbackAttendanceWithMl: () => attendanceWithMl);

  // host alias page
  Widget hostAliasPage() => Center(
      child: HostAliasTextField(
          callback: (value) {
            setState(() {
              hostAlias = value;
            });
          },
          controller: hostAliasController));

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
                          CreateRoomTitle(
                              title: contents[i].title, width: width),
                          const SizedBox(
                            height: 15,
                          ),
                          CreateRoomDesc(desc: contents[i].desc, width: width),
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
                            CreateRoomBackButton(
                                onPressed: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );

                                  FocusScope.of(context).unfocus();
                                },
                                width: width),
                            CreateRoomButton(
                                hostAlias: hostAlias,
                                roomInfo: {
                                  "room_name": roomName,
                                  "private_room": privateRoom,
                                  "attendance_with_ml": attendanceWithMl
                                },
                                width: width),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CreateRoomBackButton(
                                onPressed: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                  FocusScope.of(context).unfocus();
                                },
                                width: width),
                            CreateRoomNextButton(
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
