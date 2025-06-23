import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../managers/event_cubit/event_cubit.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(context.tr("delete_confirmation_title")),
      content: Text(context.tr("delete_confirmation_message")),
      actions: [
        CupertinoDialogAction(
          child: Text(context.tr("cancel")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(context.tr("delete_all")),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<EventCubit>().deleteAllPastEvents();
          },
        ),
      ],
    );
  }
}
