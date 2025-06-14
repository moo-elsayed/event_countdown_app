import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/add_event_cubit/add_event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/event_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EventView extends StatelessWidget {
  const EventView({super.key, required this.edit, this.event});

  final bool edit;
  final EventModel? event;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEventCubit(),
      child: Scaffold(
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
        body: EventViewBody(edit: edit, event: event),
      ),
    );
  }
}
