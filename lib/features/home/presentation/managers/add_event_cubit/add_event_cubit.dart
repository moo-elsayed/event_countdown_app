import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/add_event_cubit/add_event_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AddEventCubit extends Cubit<AddEventStates> {
  AddEventCubit() : super(AddEventInitial());

  Color color = eventColors[0];


  addEvent({required EventModel event}) async {
    if (event.title.isEmpty) {
      emit(AddEventFailure(errorMessage: "title_cannot_be_empty".tr()));
      return;
    } else if (event.dateTime.isBefore(DateTime.now())) {
      emit(AddEventFailure(errorMessage: 'event_date_in_past'.tr()));
      return;
    }
    emit(AddEventLoading());
    try {
      var notesBox = Hive.box<EventModel>(KEventsBox);
      await notesBox.add(event);
      emit(AddEventSuccess());
    } catch (e) {
      emit(AddEventFailure(errorMessage: e.toString()));
    }
  }
}
