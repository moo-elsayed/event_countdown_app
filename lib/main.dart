import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_countdown_app/features/drawer/presentation/managers/theme_cubit/theme_cubit.dart';
import 'package:event_countdown_app/features/home/presentation/views/home_view.dart';
import 'package:event_countdown_app/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/shared_preferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  final bool isDark = await SharedPreferencesManager.getMode();
  log(isDark.toString());

  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en'), const Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: MyApp(isDark: isDark),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..setMode(isDark),
      child: Builder(
        builder: (context) {
          ThemeCubit themeCubit = context.watch<ThemeCubit>();
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            darkTheme: themeCubit.isDark ? ThemeData.dark() : ThemeData.light(),
            themeMode: themeCubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}
