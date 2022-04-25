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

// home page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // appbar widget
  PreferredSizeWidget appBarWidget() => AppBar(
        // title: const Text("Atdel Demo"),
        elevation: 0,
        actions: const [SettingsButton()],
      );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        drawer: CustomDrawer(),
        body: ContentPage(),
        floatingActionButton: OptionRoomButton());
  }
}

// content page
class ContentPage extends ConsumerWidget {
  const ContentPage({Key? key}) : super(key: key);

  // scenes
  final Widget errorScene = const Center(child: Text("ERROR"));
  final Widget loadingScene = const Center(child: CircularProgressIndicator());
  final Widget noRoomsScene = const Center(child: Text("No Rooms"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(currentUser);
    final _userService = UserService();
    return ListView(
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
