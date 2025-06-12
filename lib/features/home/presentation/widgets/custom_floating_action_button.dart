import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/features/home/presentation/views/event_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final isArabic = context.locale.languageCode == 'ar';

        context.pushTransition(
          type: isArabic
              ? PageTransitionType
                    .leftToRight
              : PageTransitionType.rightToLeft,
          child: const EventView(edit: false),
        );
      },
      backgroundColor: Colors.cyan,
      child: const Icon(Icons.add,color: Colors.white),
    );
  }
}
