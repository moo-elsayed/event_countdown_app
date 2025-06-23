import 'dart:ui';
import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../../core/services/local_notification_service.dart';

class EventCubit extends Cubit<EventStates> {
  EventCubit() : super(EventInitial());

  List<EventModel> events = [];

  // is for edit
  Color color = eventColors[0];

  fetchAllEvents({String state = 'fetch'}) {
    var notesBox = Hive.box<EventModel>(KEventsBox);
    events = notesBox.values.toList();
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    switch (state) {
      case 'fetch':
        emit(FetchEventsSuccess());
        break;
      case 'delete':
        emit(DeleteEventSuccess());
        break;
      case 'delete All':
        emit(DeleteAllEventsSuccess());
        break;
      case 'edit':
        emit(EditEventSuccess());
        break;
    }
  }

  deleteEvent({required EventModel event, bool fetchEvents = true}) async {
    if (event.notificationIds != null) {
      for (int id in event.notificationIds!) {
        LocalNotificationService.cancelNotification(id: id);
      }
    }

    await event.delete();
    if (fetchEvents) {
      fetchAllEvents(state: 'delete');
    }
  }

  Future<void> deleteAllPastEvents() async {
    var box = Hive.box<EventModel>(KEventsBox);
    final now = DateTime.now();

    final pastEvents = box.values
        .where((e) => e.dateTime.isBefore(now))
        .toList();

    for (var event in pastEvents) {
      await deleteEvent(event: event, fetchEvents: false);
    }
    fetchAllEvents(state: 'delete All');
  }

  editEvent({
    required EventModel oldEvent,
    required EventModel updatedEvent,
  }) async {
    // Cancel old notifications
    if (oldEvent.notificationIds != null) {
      for (int id in oldEvent.notificationIds!) {
        LocalNotificationService.cancelNotification(id: id);
      }
    }

    oldEvent.title = updatedEvent.title;
    oldEvent.note = updatedEvent.note;
    oldEvent.color = updatedEvent.color;
    oldEvent.dateTime = updatedEvent.dateTime;

    // Schedule new notifications
    List<int> ids = await LocalNotificationService.showScheduledNotification(
      event: oldEvent,
    );
    oldEvent.notificationIds = ids;

    await oldEvent.save();
    fetchAllEvents(state: 'edit');
  }
}
