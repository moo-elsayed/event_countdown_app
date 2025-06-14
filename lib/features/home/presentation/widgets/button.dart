import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading,
    this.color,
  });

  final void Function() onPressed;
  final String title;
  final bool? isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        backgroundColor: color ?? Colors.cyan,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
        ),
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
      ),
      child: Text(title, style: GoogleFonts.lato(fontSize: 16)),
    );
  }
}
