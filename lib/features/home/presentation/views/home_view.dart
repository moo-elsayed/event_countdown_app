import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/drawer/presentation/views/drawer_view.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../managers/event_cubit/event_cubit.dart';
import '../managers/event_cubit/event_states.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_floating_action_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: drawerColor,
          child: DrawerView(scaffoldKey: scaffoldKey),
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        title: Text(
          context.tr('app_name'),
          style: GoogleFonts.lato(color: Colors.white),
        ),

        // actions:
        //     tabController.index == 1 &&
        //         context
        //             .watch<EventCubit>()
        //             .events
        //             .where((e) => e.dateTime.isBefore(DateTime.now()))
        //             .isNotEmpty
        //     ? [
        //         IconButton(
        //           icon: const Icon(Icons.delete, color: Colors.white),
        //           onPressed: () {
        //             showCupertinoDialog(
        //               context: context,
        //               builder: (context) {
        //                 return const ConfirmationDialog();
        //               },
        //             );
        //           },
        //         ),
        //       ]
        //     : [],
        actions: [
          BlocBuilder<EventCubit, EventStates>(
            buildWhen: (previous, current) =>
                current is DeleteAllEventsSuccess ||
                current is DeleteEventSuccess,
            builder: (context, state) {
              final pastEvents = context
                  .read<EventCubit>()
                  .events
                  .where((e) => e.dateTime.isBefore(DateTime.now()))
                  .toList();

              return tabController.index == 1 && pastEvents.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => const ConfirmationDialog(),
                        );
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      body: HomeViewBody(
        scaffoldKey: scaffoldKey,
        tabController: tabController,
      ),
    );
  }
}
