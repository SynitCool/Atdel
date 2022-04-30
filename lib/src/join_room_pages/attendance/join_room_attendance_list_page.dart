// flutter
import 'package:flutter/material.dart';

// model
import 'package:atdel/src/model/attendance.dart';

// services
import 'package:atdel/src/services/attendance_list_services.dart';

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/selected_room_providers.dart';

// widgets
import 'package:atdel/src/join_room_pages/attendance/widgets/attendance_page.dart';

// join attendance page
class JoinRoomAttendanceList extends ConsumerStatefulWidget {
  const JoinRoomAttendanceList({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinRoomAttendanceList> createState() =>
      _JoinRoomAttendanceListState();
}

class _JoinRoomAttendanceListState
    extends ConsumerState<JoinRoomAttendanceList> {
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

  // attendances views
  Widget attendancesView() => ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: viewedAttendances.length,
      itemBuilder: (context, index) {
        final currentData = viewedAttendances[index];

        return AttendanceListButtonWidget(attendance: currentData);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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