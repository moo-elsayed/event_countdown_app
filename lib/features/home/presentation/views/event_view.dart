import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/event_view_body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventView extends StatelessWidget {
  const EventView({super.key, required this.edit});

  final bool edit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          edit ? "edit_countdown".tr() : "add_countdown".tr(),
          style: GoogleFonts.lato(color: Colors.white),
        ),
      ),
      body: const EventViewBody(),
    );
  }
}
