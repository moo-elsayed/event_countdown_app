import 'package:hive/hive.dart';
part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? note;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final DateTime dateTime;

  EventModel({
    required this.title,
    this.note,
    required this.color,
    required this.dateTime,
  });
}
