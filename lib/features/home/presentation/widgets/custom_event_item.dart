import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/event_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants.dart';
import '../../data/event_model.dart';

class CustomEventItem extends StatelessWidget {
  const CustomEventItem({
    super.key,
    required this.event,
    required this.scaffoldKey,
  });

  final EventModel event;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final formattedDateTime = DateFormat(
      locale == 'en' ? 'dd/MM/yyyy – hh:mm a' : 'hh:mm a – yyyy/MM/dd',
      locale,
    ).format(event.dateTime);

    final difference = event.dateTime.difference(DateTime.now());

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => EventBottomSheet(
            event: event,
            scaffoldKey: scaffoldKey,
            upcomingEvent: !difference.isNegative,
          ),
        );
      },
      child: IntrinsicHeight(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(event.color),
            borderRadius: const BorderRadiusGeometry.all(Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(8),
                    event.note != null && event.note!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              event.note!,
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Row(
                      spacing: 8,
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white),
                        Text(
                          formattedDateTime,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    event.dateTime.isAfter(DateTime.now())
                        ? Center(
                            child: CircularCountDownTimer(
                              key: ValueKey(event.dateTime.toIso8601String()),
                              duration: difference.inSeconds > 0
                                  ? difference.inSeconds
                                  : 0,
                              initialDuration: 0,
                              width: 150,
                              height: 150,
                              ringColor: Colors.grey[300]!,
                              fillColor: Colors.black,
                              backgroundColor: Colors.white,
                              strokeWidth: 5,
                              strokeCap: StrokeCap.round,
                              textStyle: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textFormat: CountdownTextFormat.S,
                              timeFormatterFunction: timeFormatterFunction,
                              isReverse: true,
                              isReverseAnimation: true,
                            ),
                          )
                        : Text(
                            context.tr("countdown_ended"),
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
              // const Spacer(),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: 1,
                    decoration: const BoxDecoration(color: dividerColor),
                  ),
                  Transform.rotate(
                    angle: -pi / 2,
                    child: Text(
                      context.tr("event"),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  timeFormatterFunction(defaultFormatterFunction, duration) {
    int totalSeconds = duration.inSeconds;

    int days = totalSeconds ~/ (24 * 3600);
    int hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formatNumber(int n) => n.toString().padLeft(2, '0');

    String result = '';

    if (days > 0) {
      result += '${formatNumber(days)}:';
    }

    if (hours > 0 || days > 0) {
      result += '${formatNumber(hours)}:';
    }

    if (minutes > 0 || hours > 0 || days > 0) {
      result += '${formatNumber(minutes)}:';
    }

    if (days == 0 && hours == 0 && minutes == 0 && seconds <= 9) {
      result += seconds.toString(); // بدون padding
    } else {
      result += formatNumber(seconds); // 2 digits
    }

    return result;
  }
}
