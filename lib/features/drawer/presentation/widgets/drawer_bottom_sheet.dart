import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text(
                  'app_language'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          buildRadioListTile(
            currentLocale,
            scaffoldKey.currentContext!,
            currentLocale == 'ar' ? 'ar' : 'en',
          ),
          buildRadioListTile(
            currentLocale,
            scaffoldKey.currentContext!,
            currentLocale == 'ar' ? 'en' : 'ar',
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  RadioListTile<String> buildRadioListTile(
    String currentLocale,
    BuildContext context,
    String languageCode,
  ) {
    return RadioListTile<String>(
      value: languageCode,
      groupValue: currentLocale,
      onChanged: (value) async {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 300));
        context.setLocale(Locale(languageCode));
      },

      title: Text(
        languageCode == 'en' ? 'English' : 'العربية',
        style: const TextStyle(color: Colors.white),
      ),
      activeColor: Colors.amber,
    );
  }
}
