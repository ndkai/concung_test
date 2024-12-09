import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../config/theme/bloc/theme_bloc.dart';
import '../../config/theme/bloc/theme_event.dart';
import '../../config/theme/theme.dart';

class ThemeBuilderApp extends StatefulWidget {
  final Widget child;
  final ThemeType initTheme;
  const ThemeBuilderApp({super.key, required this.child, this.initTheme = ThemeType.light});

  @override
  State<ThemeBuilderApp> createState() => _ThemeBuilderAppState();
}

class _ThemeBuilderAppState extends State<ThemeBuilderApp> {
  @override
  Widget build(BuildContext context) {
    final appTheme = GetIt.instance<AppTheme>();
    return BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc()..add(ToggleThemeEvent(type: widget.initTheme)),
        child: BlocBuilder<ThemeBloc, ThemeType>(
          builder: (context, themeType) {
            final theme = themeType == ThemeType.light
                ? appTheme.lightTheme
                : appTheme.darkTheme;
            appTheme.initCurrentTheme(theme);
            return MaterialApp(
              title: 'Flutter Demo',
              theme: theme,
              home: Scaffold(
                backgroundColor: AppTheme.currentTheme.colorScheme.surface,
                body: widget.child,
              ),
            );
          },
        ));
  }
}
