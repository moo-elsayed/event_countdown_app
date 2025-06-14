import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../views/event_view.dart';

class EventBottomSheet extends StatelessWidget {
  const EventBottomSheet({
    super.key,
    required this.event,
    required this.scaffoldKey,
  });

  final EventModel event;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    EventCubit cubit = context.read<EventCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text(
                  event.title,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              spacing: 24,
              children: [
                Button(
                  onPressed: () {
                    final isArabic = context.locale.languageCode == 'ar';

                    Navigator.pop(context);

                    Future.delayed(
                      const Duration(microseconds: 500),
                      () => scaffoldKey.currentContext!.pushTransition(
                        type: isArabic
                            ? PageTransitionType.leftToRight
                            : PageTransitionType.rightToLeft,
                        child: EventView(edit: true, event: event),
                      ),
                    );
                  },
                  title: "edit_event".tr(),
                  color: editEventColor,
                ),
                Button(
                  onPressed: () {
                    cubit.deleteEvent(event: event);
                    Navigator.pop(context);
                  },
                  title: "delete_event".tr(),
                  color: deleteEventColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
