import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart'
    show
        DateFormat,
        BuildContextEasyLocalizationExtension,
        StringTranslateExtension;
import 'package:event_countdown_app/core/functions.dart';
import 'package:event_countdown_app/features/home/data/event_model.dart';
import 'package:event_countdown_app/features/home/presentation/managers/add_event_cubit/add_event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/managers/add_event_cubit/add_event_states.dart';
import 'package:event_countdown_app/features/home/presentation/managers/event_cubit/event_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/button.dart';
import 'package:event_countdown_app/features/home/presentation/widgets/colors_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_text_form_filed.dart';

class EventViewBody extends StatefulWidget {
  const EventViewBody({super.key, required this.edit});

  final bool edit;

  @override
  State<EventViewBody> createState() => _EventViewBodyState();
}

class _EventViewBodyState extends State<EventViewBody> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String currentTimeEN = DateFormat('hh:mm a', 'en').format(DateTime.now());
  String currentTimeAR = DateFormat('hh:mm a', 'ar').format(DateTime.now());
  String? errorMessage;

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    errorMessage = "title_cannot_be_empty".tr();
    AddEventCubit cubit = context.read<AddEventCubit>();
    return BlocConsumer<AddEventCubit, AddEventStates>(
      listener: (context, state) {
        if (state is AddEventFailure) {
          errorMessage = state.errorMessage;
          showCustomSnackBar(
            context: context,
            title: "error".tr(),
            message: errorMessage!,
            contentType: ContentType.failure,
          );
          autoValidateMode = AutovalidateMode.always;
          setState(() {});
        } else if (state is AddEventSuccess) {
          showCustomSnackBar(
            context: context,
            title: "success".tr(),
            message: "add_event_success".tr(),
            contentType: ContentType.success,
          );
          context.read<EventCubit>().fetchAllEvents();
          Future.delayed(
            const Duration(microseconds: 300),
            () => Navigator.pop(context),
          );
        }
      },
      builder: (context, state) => Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),
                titleEvent(),
                const Gap(24),
                noteEvent(),
                const Gap(24),
                Row(
                  spacing: 24,
                  children: [
                    Expanded(child: dateEvent()),
                    Expanded(child: timeEvent()),
                  ],
                ),
                const Gap(24),
                Text("color".tr(), style: GoogleFonts.lato(fontSize: 16)),
                const Gap(8),
                ColorsListView(edit: widget.edit),
                const Gap(24),
                Button(
                  onPressed: () {
                    cubit.addEvent(
                      event: EventModel(
                        title: titleController.text,
                        note: noteController.text,
                        color: cubit.color.toARGB32(),
                        dateTime: DateTime(
                          currentDate.year,
                          currentDate.month,
                          currentDate.day,
                          currentTime.hour,
                          currentTime.minute,
                        ),
                      ),
                    );
                  },
                  title: "save".tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column titleEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('title'.tr(), style: GoogleFonts.lato(fontSize: 16)),
        const Gap(8),
        CustomTextFormField(
          errorMessage: errorMessage,
          controller: titleController,
          hintText: 'enter_title_here'.tr(),
        ),
      ],
    );
  }

  Column noteEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${'note'.tr()} ${'optional'.tr()}",
          style: GoogleFonts.lato(fontSize: 16),
        ),
        const Gap(8),
        CustomTextFormField(
          controller: noteController,
          hintText: 'enter_note_here'.tr(),
        ),
      ],
    );
  }

  Column dateEvent() {
    final locale = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('date'.tr(), style: GoogleFonts.lato(fontSize: 16)),
        const Gap(8),
        CustomTextFormField(
          readOnly: true,
          hintText: locale == 'en'
              ? DateFormat('dd/MM/yyyy', locale).format(currentDate)
              : DateFormat('yyyy/MM/dd', locale).format(currentDate),
          suffixIcon: Icons.calendar_month_outlined,
          tapOnSuffixIcon: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: DateTime.now(),
              lastDate: DateTime(2050),
            );
            log(pickedDate.toString());
            setState(() {
              if (pickedDate != null) currentDate = pickedDate;
            });
          },
        ),
      ],
    );
  }

  Column timeEvent() {
    final locale = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('time'.tr(), style: GoogleFonts.lato(fontSize: 16)),
        const Gap(8),
        CustomTextFormField(
          readOnly: true,
          hintText: locale == 'ar' ? currentTimeAR : currentTimeEN,
          suffixIcon: Icons.timer_outlined,
          tapOnSuffixIcon: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            log(pickedTime.toString());
            setState(() {
              if (pickedTime != null) {
                currentTimeEN = pickedTime.format(context);
                currentTimeAR = pickedTime.format(context);
                currentTime = pickedTime;
              }
            });
          },
        ),
      ],
    );
  }
}
