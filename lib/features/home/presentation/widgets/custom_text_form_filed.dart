import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.labelText,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.tapOnSuffixIcon,
    this.readOnly,
    this.errorMessage,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? errorMessage;
  final void Function(String)? onChanged;
  final void Function()? tapOnSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.cyan,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      validator: (val) {
        if (val!.isEmpty && errorMessage != null) {
          return errorMessage ?? 'field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: textFormFieldFillColor,
        labelText: labelText,
        hintText: hintText,
        hintStyle: GoogleFonts.lato(color: Colors.white, fontSize: 16),
        prefixIcon: prefixIcon,
        suffixIcon: GestureDetector(
          onTap: tapOnSuffixIcon,
          child: Icon(suffixIcon, color: Colors.white),
        ),
        border: getBorder(),
        enabledBorder: getBorder(),
        errorBorder: getBorder(),
        focusedBorder: getBorder(color: Colors.white),
      ),
    );
  }

  OutlineInputBorder getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color ?? textFormFieldBorderColor),
    );
  }
}
