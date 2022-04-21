// flutter
import 'package:flutter/material.dart';

// custom widgets
import 'package:floating_action_bubble/floating_action_bubble.dart';

// widgets
import 'package:atdel/src/host_room_pages/attendance/widgets/attendance_pages.dart';

// pages
import 'package:atdel/src/host_room_pages/attendance/add_attendance_list_pages.dart';

// model
import 'package:atdel/src/model/attendance.dart';
import 'package:atdel/src/model/room.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// services
import 'package:atdel/src/services/attendance_list_services.dart';
import 'package:atdel/src/services/convert2excel_services.dart';
import 'package:atdel/src/services/room_services.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// icons
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// attendance list screen
class AttendanceListPage extends ConsumerWidget {
  const AttendanceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final selectedRoomProvider = ref.watch(selectedRoom);

    // services
    final roomService = RoomService();
    return FutureBuilder<Room>(
        future: roomService.getRoomInfo(selectedRoomProvider.room!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AttendancePageLoadingScreen();
          }

          if (snapshot.hasError) return const AttendancePageErrorScreen();

          final data = snapshot.data;

          if (data == null) return const AttendancePageLoadingScreen();

          if (data.privateRoom) return const AttendancePagePrivateRoom();

          return const AttendancePagePublicRoom();
        });
  }
}

// attendance page for private room
class AttendancePagePrivateRoom extends StatelessWidget {
  const AttendancePagePrivateRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Set the private room first to use attendance list."),
      ),
    );
  }
}

// attendance page for public room
class AttendancePagePublicRoom extends ConsumerStatefulWidget {
  const AttendancePagePublicRoom({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendancePagePublicRoom> createState() =>
      _AttendancePagePublicRoomState();
}

class _AttendancePagePublicRoomState
    extends ConsumerState<AttendancePagePublicRoom>
    with SingleTickerProviderStateMixin {
  // floating action button animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  // scene
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget errorScene = const Center(child: Text("ERROR"));

  // services
  final AttendanceListService _attendanceListService = AttendanceListService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  // add attendance button
  Bubble addAttendanceButton() => Bubble(
      icon: Icons.add,
      iconColor: Colors.white,
      title: "Add",
      titleStyle: const TextStyle(color: Colors.white),
      bubbleColor: Colors.blue,
      onPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddAttendanceListPage()));
      });

  // convert attendance to excel button
  Bubble convertToExcel() {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Bubble(
        icon: FontAwesomeIcons.fileExcel,
        iconColor: Colors.white,
        title: "Convert2Excel",
        titleStyle: const TextStyle(color: Colors.white),
        bubbleColor: Colors.blue,
        onPress: () {
          final ConvertToExcelService convertToExcelService =
              ConvertToExcelService();

          convertToExcelService
              .convertByAttendanceList(_selectedRoomProvider.room!);
        });
  }

  // floating action button of attendance list screen
  Widget floatingActionButtonWidget() => FloatingActionBubble(
      items: [addAttendanceButton(), convertToExcel()],
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: Colors.white,
      backGroundColor: Colors.blue,
      animation: _animation,
      iconData: Icons.menu);

  @override
  Widget build(BuildContext context) {
    final _selectedRoomProvider = ref.watch(selectedRoom);
    return Scaffold(
        floatingActionButton: floatingActionButtonWidget(),
        body: StreamBuilder<List<Attendance>>(
          stream: _attendanceListService
              .streamAttendanceList(_selectedRoomProvider.room!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingScene;
            }

            if (snapshot.hasError) return errorScene;

            final data = snapshot.data;

            if (data!.isEmpty) {
              return const Center(child: Text("No attendance"));
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final currentData = data[index];

                  return AttendanceButtonWidget(attendance: currentData);
                });
          },
        ));
  }
}