import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/drawer/presentation/views/drawer_view.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: const HomeViewBody(),
    );
  }
}
