import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/shared_preferences_manager.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitial());
  late bool isDark;

  void setMode(bool mode) {
    isDark = mode;
  }

  void changeMode() {
    isDark = !isDark;
    SharedPreferencesManager.setMode(isDark);
    emit(NewState());
  }
}

abstract class ThemeStates {}

class ThemeInitial extends ThemeStates {}

class NewState extends ThemeStates {}
