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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Get the screen dimensions
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;
                double scaleFactor = 2.5;
                double width = screenWidth * 0.55;
                double height = width / scaleFactor;
                double padding = width * (12.5 / 369);
                return Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        height: height,
                        width: width,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: padding,
                              child: SvgPicture.asset(Assets.dayClouds,
                                  width: width * (386 / 369)),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: SvgPicture.asset(
                                Assets.dayCloudsbacks,
                                width: width * (377 / 369),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: SvgPicture.asset(
                                Assets.dayRays,
                                height: height,
                              ),
                            ),
                            Positioned(
                                left: padding,
                                top: padding,
                                child: SvgPicture.asset(
                                  Assets.daySun,
                                  height: height * 120 / 145,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
