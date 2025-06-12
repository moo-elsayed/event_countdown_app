import 'dart:developer';
import 'package:easy_localization/easy_localization.dart'
    show
        DateFormat,
        BuildContextEasyLocalizationExtension,
        StringTranslateExtension;
import 'package:event_countdown_app/features/home/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_text_form_filed.dart';

class EventViewBody extends StatefulWidget {
  const EventViewBody({super.key});

  @override
  State<EventViewBody> createState() => _EventViewBodyState();
}

class _EventViewBodyState extends State<EventViewBody> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  DateTime currentDate = DateTime.now();
  String currentTimeEN = DateFormat('hh:mm a', 'en').format(DateTime.now());
  String currentTimeAR = DateFormat('hh:mm a', 'ar').format(DateTime.now());

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autoValidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Button(onPressed: () {}, title: "save".tr()),
          ],
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
        Text('note'.tr(), style: GoogleFonts.lato(fontSize: 16)),
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
              }
            });
          },
        ),
      ],
    );
  }
}
