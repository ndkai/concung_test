import 'package:meta/meta.dart';

import '../theme.dart';

@immutable
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent{
  final ThemeType? type;

  ToggleThemeEvent({this.type});
}