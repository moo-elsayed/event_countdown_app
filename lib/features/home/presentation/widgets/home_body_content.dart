import 'package:flutter/material.dart';
import '../../data/event_model.dart';
import 'custom_event_item.dart';

class HomeBodyContent extends StatelessWidget {
  const HomeBodyContent({
    super.key,
    required this.events,
    required this.scaffoldKey,
  });

  final List<EventModel> events;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: index == events.length - 1 ? 20 : 0,
          ),
          child: CustomEventItem(
            event: events[index],
            scaffoldKey: scaffoldKey,
          ),
        );
      },
    );
  }
}
