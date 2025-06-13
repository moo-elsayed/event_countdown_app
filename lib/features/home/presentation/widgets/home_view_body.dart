import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventStates>(
      builder: (context, state) => Center(
        child: Text(context.read<EventCubit>().events.length.toString()),
      ),
    );
  }
}
