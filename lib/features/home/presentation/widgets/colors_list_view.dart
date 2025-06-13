import 'package:event_countdown_app/constants.dart';
import 'package:event_countdown_app/features/home/presentation/managers/add_event_cubit/add_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_item.dart';

class ColorsListView extends StatefulWidget {
  const ColorsListView({super.key, required this.edit});

  final bool edit;

  @override
  State<ColorsListView> createState() => _ColorsListViewState();
}

class _ColorsListViewState extends State<ColorsListView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18 * 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsetsDirectional.only(start: index != 0 ? 12 : 0),
          child: GestureDetector(
            onTap: () {
              this.index = index;
              if (!widget.edit) {
                context.read<AddEventCubit>().color = eventColors[index];
              }
              setState(() {});
            },
            child: ColorItem(
              isSelected: this.index == index ? true : false,
              color: eventColors[index],
            ),
          ),
        ),
        itemCount: eventColors.length,
      ),
    );
  }
}
