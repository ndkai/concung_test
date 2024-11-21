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
          body: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Get the screen dimensions
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;
                double scaleFactor = 1.5;

                return Center(
                    child: SizedBox(
                  height: screenHeight * 0.8,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                          height: 130,
                          width: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Stack(
                            children: [

                              Positioned(child: SvgPicture.asset(Assets.dayClouds),right: -10, bottom: -10,),
                              Positioned(child: SvgPicture.asset(Assets.dayCloudsbacks), right: -10,),
                              Positioned(child: SvgPicture.asset(Assets.dayRays), left: -10,),
                              Padding(padding: EdgeInsets.all(8),child: SvgPicture.asset(Assets.daySun),),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
