import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme.dart';

class DIService {
  static final sl = GetIt.instance;

  Future init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
    final theme = await AppTheme().init(sl());
    sl.registerSingleton<AppTheme>(theme);
  }
}