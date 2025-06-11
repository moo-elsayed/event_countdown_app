import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/features/drawer/presentation/managers/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/drawer_bottom_sheet.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    ThemeCubit themeCubit = context.watch<ThemeCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 18,
            top: 46,
            bottom: 24,
          ),
          child: Text(
            'app_name'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(color: Colors.white24),
        ListTile(
          onTap: () => themeCubit.changeMode(),
          title: Text(
            themeCubit.isDark ? 'theme_mode'.tr() : 'theme_mode_light'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Icon(
            themeCubit.isDark ? Icons.dark_mode : Icons.light_mode,
            color: themeCubit.isDark ? Colors.blueGrey : Colors.amber,
          ),
          trailing: Switch(
            value: themeCubit.isDark,
            onChanged: (value) => themeCubit.changeMode(),
            activeColor: themeCubit.isDark ? Colors.blueGrey : Colors.amber,
            inactiveThumbColor: Colors.grey[600],
            inactiveTrackColor: Colors.grey[800],
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 300), () {
              showModalBottomSheet(
                context: scaffoldKey.currentContext!,
                backgroundColor: Colors.grey[900],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) =>
                    LanguageBottomSheet(scaffoldKey: scaffoldKey),
              );
            });
          },
          leading: const Icon(Icons.language, color: Colors.white),
          title: Text(
            'app_language'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            context.locale.languageCode == 'en' ? 'English' : 'العربية',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
