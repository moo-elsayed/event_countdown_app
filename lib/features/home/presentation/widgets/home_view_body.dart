import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_event_item.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    EventCubit cubit = context.watch<EventCubit>();
    List<EventModel> events = cubit.events;
    return events.isEmpty
        ? Center(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/event_scheduling.svg'),
                Text(
                  context.tr('no_events_scheduled'),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  context.tr('tap_to_add_event'),
                  style: GoogleFonts.lato(fontSize: 16),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomEventItem(event: events[index], scaffoldKey: scaffoldKey,),
              );
            },
          );
  }
}
