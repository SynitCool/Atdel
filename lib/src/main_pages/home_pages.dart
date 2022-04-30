// flutter
import 'package:flutter/material.dart';

// home pages feature
import 'package:atdel/src/main_pages/widgets/home_drawer.dart';

// services
import 'package:atdel/src/services/user_services.dart';

// model
import 'package:atdel/src/model/user.dart' as src_user;

// state management
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers
import 'package:atdel/src/providers/current_user_providers.dart';

// widgets
import 'package:atdel/src/main_pages/widgets/home_pages.dart';

// connection
import 'package:connectivity_plus/connectivity_plus.dart';

// home page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic connectionSubscription;

  // check connection
  bool connection = true;

  @override
  void initState() {
    super.initState();

    connectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result.name == "none") {
        setState(() {
          connection = false;
        });

        return;
      }

      setState(() {
        connection = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    connectionSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: connection
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.blue,
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: const Text('Please check your internet connection',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
            ),
            preferredSize: const Size.fromHeight(0)),
        drawer: const CustomDrawer(),
        body: const ContentPage(),
        floatingActionButton: const OptionRoomButton());
  }
}

// content page
class ContentPage extends ConsumerWidget {
  const ContentPage({Key? key}) : super(key: key);

  // scenes
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget noRoomsScene = const Center(child: Text("No Rooms"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget loadingScene = Column(children: const [
      SizedBox(height: 100),
      Center(child: CircularProgressIndicator())
    ]);

    final provider = ref.watch(currentUser);
    final _userService = UserService();
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        CustomAppBar(height: MediaQuery.of(context).size.height),
        StreamBuilder<src_user.User>(
            stream: _userService.streamUser(provider.user!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingScene;
              }

              if (snapshot.hasError) return errorScene;

              final data = snapshot.data;
              final references = data!.roomReferences;

              if (references.isEmpty) return noRoomsScene;

              return ListView.builder(
                  itemCount: references.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final currentReference = references[index];

                    return RoomStreamBuilder(reference: currentReference);
                  });
            }),
      ],
    );
  }
}
