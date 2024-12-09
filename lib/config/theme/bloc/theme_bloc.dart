
import 'package:bloc/bloc.dart';

import '../theme.dart';
import 'bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeType> {
  ThemeType currentTheme = ThemeType.light;
  ThemeBloc() : super(ThemeType.light) {
    on<ToggleThemeEvent>(_toggleTheme);
  }

  void _toggleTheme(ToggleThemeEvent event, Emitter<ThemeType> state) {
    if(event.type != null){
      currentTheme = event.type!;
      emit(event.type!);
      return;
    }
    if(currentTheme == ThemeType.light){
      currentTheme = ThemeType.dark;
      emit(ThemeType.dark);
    } else {
      currentTheme = ThemeType.light;
      emit(ThemeType.light);
    }

  }
}
