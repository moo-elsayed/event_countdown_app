import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NoEventsWidget extends StatelessWidget {
  const NoEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/event_scheduling.svg'),
        Text(
          context.tr('no_events_scheduled'),
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(
          context.tr('tap_to_add_event'),
          style: GoogleFonts.lato(fontSize: 16),
        ),
      ],
    );
  }
}
