// flutter
import 'package:atdel/src/services/selected_users_services.dart';
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
class AttendancePagePrivateRoom extends ConsumerWidget {
  const AttendancePagePrivateRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // services
    final selectedUsersServices = SelectedUsersServices();

    // providers
    final selectedRoomProvider = ref.watch(selectedRoom);

    return FutureBuilder<bool>(
        future: selectedUsersServices
            .checkSelectedUsersExist(selectedRoomProvider.room!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) return const Center(child: Text("ERROR"));

          final exist = snapshot.data;

          if (exist == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (exist) return const AttendancePagePublicRoom();

          return const Center(
            child: Text("Set the private room first to use attendance list."),
          );
        });
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

  // attendances
  List<Attendance> attendances = [];
  List<Attendance> viewedAttendances = [];

  // filter active attendance
  void filterActiveAttendances() {
    List<Attendance> activeAttendances = [];
    List<Attendance> notActiveAttendances = [];

    for (var element in attendances) {
      if (element.attendanceActive) activeAttendances.add(element);
      if (!element.attendanceActive) notActiveAttendances.add(element);
    }

    setState(() {
      viewedAttendances = activeAttendances;
      // attendances.addAll(notActiveAttendances);
    });
  }

  // filter active attendance
  void filterNotActiveAttendances() {
    List<Attendance> activeAttendances = [];
    List<Attendance> notActiveAttendances = [];

    for (var element in attendances) {
      if (element.attendanceActive) activeAttendances.add(element);
      if (!element.attendanceActive) notActiveAttendances.add(element);
    }

    setState(() {
      viewedAttendances = notActiveAttendances;
      // attendances.addAll(notActiveAttendances);
    });
  }

  // filter active attendance
  void filterDefaultAttendances() {
    setState(() {
      viewedAttendances = attendances;
      // attendances.addAll(notActiveAttendances);
    });
  }


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

  // stream builder
  Widget streamBuildAttendancesView() {
    final _selectedRoomProvider = ref.watch(selectedRoom);

    return StreamBuilder<List<Attendance>>(
      stream: _attendanceListService
          .streamAttendanceList(_selectedRoomProvider.room!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScene;
        }

        if (snapshot.hasError) return errorScene;

        final data = snapshot.data;

        if (data == null) return loadingScene;

        attendances = data;
        viewedAttendances = data;

        if (data.isEmpty) {
          return const Center(child: Text("No attendance"));
        }

        return attendancesView();
      },
    );
  }

  // attendances views
  Widget attendancesView() => ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: viewedAttendances.length,
      itemBuilder: (context, index) {
        final currentData = viewedAttendances[index];

        return AttendanceButtonWidget(attendance: currentData);
      });

  // filterWidget
  Widget filterWidget() => FilteredSections(
        filterButtons: [
          PopupMenuItem(
            child: const Text("Default"),
            onTap: filterDefaultAttendances,
          ),
          PopupMenuItem(
            child: const Text("Active"),
            onTap: filterActiveAttendances,
          ),
          PopupMenuItem(
            child: const Text("Not Active"),
            onTap: filterNotActiveAttendances,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButtonWidget(),
        body: attendances.isEmpty
            ? Column(
                children: [
                  filterWidget(),
                  streamBuildAttendancesView(),
                ],
              )
            : Column(
                children: [
                  filterWidget(),
                  attendancesView(),
                ],
              ));
  }
}
