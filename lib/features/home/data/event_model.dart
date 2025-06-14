import 'package:hive/hive.dart';
part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? note;

  @HiveField(2)
  int color;

  @HiveField(3)
  DateTime dateTime;

  EventModel({
    required this.title,
    this.note,
    required this.color,
    required this.dateTime,
  });
}
