import 'package:concung_test/button/adaptive_button.dart';
import 'package:concung_test/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'config/theme/bloc/theme_bloc.dart';
import 'config/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.nightRays,
                  height: 100,
                ),
                SvgPicture.asset(
                  Assets.dayRays,
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
