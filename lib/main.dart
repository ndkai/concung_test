import 'package:concung_test/generated/assets.dart';
import 'package:concung_test/ui/button/adaptive_button.dart';
import 'package:concung_test/ui/theme_builder/theme_builder_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'config/di/di.dart';
import 'config/theme/bloc/theme_bloc.dart';
import 'config/theme/bloc/theme_event.dart';
import 'config/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DIService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ThemeBuilderApp(child: LayoutBuilder(builder: (context, constraints){
      return Center(
        child: AdaptiveButton(key: UniqueKey(), width: constraints.maxWidth * 0.5, changeDayDuration: const Duration(milliseconds: 1000)),
      );
    }));
  }
}
