import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EventCubit extends Cubit<EventStates> {
  EventCubit() : super(EventInitial());

  List<EventModel> events = [];

  fetchAllEvents() {
    var notesBox = Hive.box<EventModel>(KEventsBox);
    events = notesBox.values.toList();
    emit(EventSuccess());
  }
}
