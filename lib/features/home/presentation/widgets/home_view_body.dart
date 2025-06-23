import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_states.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/no_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/functions.dart';
import 'home_body_content.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
    required this.scaffoldKey,
    required this.tabController,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCubit, EventStates>(
      listener: (context, state) {
        if (state is DeleteEventSuccess) {
          showCustomToast(
            context: context,
            message: context.tr("event_deleted_successfully"),
            contentType: ContentType.success,
          );
        } else if (state is DeleteAllEventsSuccess) {
          showCustomToast(
            context: context,
            message: context.tr("events_deleted_successfully"),
            contentType: ContentType.success,
          );
        } else if (state is EditEventSuccess) {
          showCustomToast(
            context: context,
            message: context.tr("event_edited_successfully"),
            contentType: ContentType.success,
          );
        }
      },
      builder: (context, state) {
        final events = context.read<EventCubit>().events;
        final now = DateTime.now();

        final upcomingEvents = events
            .where((e) => e.dateTime.isAfter(now))
            .toList();
        final pastEvents = events
            .where((e) => e.dateTime.isBefore(now))
            .toList();

        return Column(
          children: [
            const Gap(12),
            Center(
              child: IntrinsicWidth(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    labelStyle: GoogleFonts.lato(fontWeight: FontWeight.w600),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tabs: [
                      Tab(text: context.tr('tab_upcoming_events')),
                      Tab(text: context.tr('tab_past_events')),
                    ],
                    dividerColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  upcomingEvents.isEmpty
                      ? const NoEventsWidget()
                      : HomeBodyContent(
                          scaffoldKey: scaffoldKey,
                          events: upcomingEvents,
                        ),
                  pastEvents.isEmpty
                      ? const NoEventsWidget()
                      : HomeBodyContent(
                          scaffoldKey: scaffoldKey,
                          events: pastEvents,
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
