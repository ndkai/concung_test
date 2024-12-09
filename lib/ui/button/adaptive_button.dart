import 'package:concung_test/config/theme/bloc/bloc.dart';
import 'package:concung_test/config/theme/theme.dart';
import 'package:concung_test/core/exception/exception_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';

class AdaptiveButton extends StatefulWidget {
  final double width;
  final Duration? changeDayDuration;

  const AdaptiveButton({
    super.key,
    this.width = 300,
    this.changeDayDuration,
  });

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton>
    with TickerProviderStateMixin {
  // Constants for scaling and layout
  final double scaleFactor = 2.5; // Determines height-to-width ratio
  late double width; // Default width of the button

  // Calculated layout properties
  late double height;
  late double padding;
  late double transformDayNightDistance;

  // Animation controllers and animations
  late AnimationController _hoverAnimationController;
  late Animation<double> _hoverAnimation;

  late AnimationController _changeDayAnimationController;
  late Animation<double> _changeDayAnimation;

  // State to determine if it's "day" or "night"
  bool isDay = true;

  @override
  void initState() {
    super.initState();
    // Calculate dimensions based on width and scale factor
    width = widget.width;
    height = width / scaleFactor;
    padding = width * (12.5 / 369);
    transformDayNightDistance = width - 2 * padding - height * (120 / 145);

    // Initialize animations
    _initHoverAnimation();
    _initChangeDayAnimation();
  }

  void _initHoverAnimation() {
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hoverAnimation =
        Tween<double>(begin: 0, end: 20).animate(_hoverAnimationController);
  }

  void _initChangeDayAnimation() {
    _changeDayAnimationController = AnimationController(
      vsync: this,
      duration: widget.changeDayDuration ?? const Duration(milliseconds: 1500),
    );
    double begin = 0;
    double end = transformDayNightDistance;
    _changeDayAnimation = Tween<double>(begin: begin, end: end)
        .animate(_changeDayAnimationController);
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    _changeDayAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width),
      child: AnimatedBuilder(
        animation: _changeDayAnimation,
        builder: (_, child) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Color.lerp(Colors.blue, Colors.black,
                  _changeDayAnimationController.value),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            CloudFront(
              hoverAnimation: _hoverAnimation,
              transformAnimation: _changeDayAnimation,
              width: width,
              padding: padding,
            ),
            CloudBack(
              hoverAnimation: _hoverAnimation,
              transformAnimation: _changeDayAnimation,
              width: width,
              padding: padding,
            ),
            Rays(
              hoverAnimation: _hoverAnimation,
              transformAnimation: _changeDayAnimation,
              height: height,
              padding: padding, transformAnimationController: _changeDayAnimationController,
            ),
            SunAndMoon(
              hoverAnimation: _hoverAnimation,
              height: height,
              padding: padding,
              transformAnimation: _changeDayAnimation,
              onDayHoverStart: () {
                _hoverAnimationController.forward();
              },
              onDayHoverExit: () {
                _hoverAnimationController.reverse();
              },
              onStartChangeDay: () {
                _changeDayAnimationController.forward().then((_) {
                  context
                      .read<ThemeBloc>()
                      .add(ToggleThemeEvent(type: ThemeType.dark));
                  setState(() {
                    isDay = false;
                  });
                });
              },
              onReverseChangeDay: () async {
                await _hoverAnimationController.reverse();
                _changeDayAnimationController.reverse().then((_) {
                  context
                      .read<ThemeBloc>()
                      .add(ToggleThemeEvent(type: ThemeType.light));
                  setState(() {
                    isDay = true;
                  });
                });

              },
              changeDayAnimationController: _changeDayAnimationController,
            ),
            Stars(
              transformAnimation: _changeDayAnimation,
              width: width,
              transformDayNightDistance: transformDayNightDistance,
            ),
          ],
        ),
      ),
    );
  }
}

class SunAndMoon extends StatelessWidget {
  final AnimationController changeDayAnimationController;
  final Animation<double> hoverAnimation;
  final Animation<double> transformAnimation;
  final double height;
  final double padding;
  final Function onDayHoverStart;
  final Function onDayHoverExit;
  final Function onStartChangeDay;
  final Function onReverseChangeDay;

  const SunAndMoon({
    required this.hoverAnimation,
    required this.height,
    required this.padding,
    super.key,
    required this.transformAnimation,
    required this.onDayHoverStart,
    required this.onDayHoverExit,
    required this.onStartChangeDay,
    required this.onReverseChangeDay,
    required this.changeDayAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    double size = height * (120 / 145);
    return AnimatedBuilder(
      animation: Listenable.merge([hoverAnimation, transformAnimation]),
      builder: (context, child) {
        /*
        * Check when hover the sun or moon
        * if current type is morning -> animation sun to right
        * if current type is night -> animation moon to left
        * */
        double hoverValue = hoverAnimation.value;
        if (changeDayAnimationController.value == 1) {
          hoverValue = -hoverAnimation.value;
        }
        return Positioned(
          left: padding + hoverValue + transformAnimation.value,
          top: padding,
          child: MouseRegion(
            onEnter: (_){
              onDayHoverStart();
            },
            onExit: (_){
              onDayHoverExit();
            },
            child: GestureDetector(
              onTap: (){
                onStartChangeDay.safeCall();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height),
                child: Stack(
                  children: [
                    _buildSun(size),
                    _buildMoon(size)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSun(double size){
    return changeDayAnimationController.value < 0.9
        ? SvgPicture.asset(Assets.daySun, height: size)
        : SizedBox(
      height: size,
      width: size,
    );
  }

  Widget _buildMoon(double size){
    return AnimatedBuilder(
        animation: transformAnimation,
        builder: (context, child) {
          return Positioned(
            left: size * 1.5 -
                size *
                    1.5 *
                    changeDayAnimationController.value,
            child: MouseRegion(

              child: GestureDetector(
                onTap: (){
                  onReverseChangeDay();
                },
                child: SvgPicture.asset(Assets.nightMoon,
                    height: size),
              ),
            ),
          );
        });
  }
}

class Rays extends StatelessWidget {
  final AnimationController transformAnimationController;
  final Animation<double> hoverAnimation;
  final Animation<double> transformAnimation;
  final double height;
  final double padding;

  const Rays({
    required this.hoverAnimation,
    required this.height,
    required this.padding,
    super.key,
    required this.transformAnimation, required this.transformAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    double size = height * (368 / 145);
    double marginAll = -(size - height) / 2;
    return AnimatedBuilder(
      animation: Listenable.merge([hoverAnimation, transformAnimation]),
      builder: (context, child) {
        /*
        * Check when hover the sun or moon
        * if current type is morning -> animation rays to right
        * if current type is night -> animation rays to left
        * */
        double hoverValue = hoverAnimation.value;
        if (transformAnimationController.value == 1) {
          hoverValue = -hoverAnimation.value;
        }
        return Positioned(
          top: marginAll,
          left: marginAll + hoverValue + transformAnimation.value,
          child: SvgPicture.asset(Assets.dayRays, height: size, width: size),
        );
      },
    );
  }
}

class CloudBack extends StatelessWidget {
  final Animation<double> hoverAnimation;
  final Animation<double> transformAnimation;
  final double width;
  final double padding;

  const CloudBack({
    required this.hoverAnimation,
    required this.width,
    required this.padding,
    super.key,
    required this.transformAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([transformAnimation, hoverAnimation]),
      builder: (context, child) {
        return Positioned(
          bottom: -hoverAnimation.value - transformAnimation.value,
          left: 0,
          child: SvgPicture.asset(Assets.dayCloudsbacks,
              width: width * (377 / 369)),
        );
      },
    );
  }
}

class CloudFront extends StatelessWidget {
  final Animation<double> hoverAnimation;
  final Animation<double> transformAnimation;
  final double width;
  final double padding;

  const CloudFront({
    required this.hoverAnimation,
    required this.width,
    required this.padding,
    Key? key,
    required this.transformAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([transformAnimation, hoverAnimation]),
      builder: (context, child) {
        return Positioned(
          bottom: -hoverAnimation.value - transformAnimation.value,
          left: padding,
          child: SvgPicture.asset(Assets.dayClouds, width: width * (386 / 369)),
        );
      },
    );
  }
}

class Stars extends StatelessWidget {
  final Animation<double> transformAnimation;
  final double width;
  final double transformDayNightDistance;

  const Stars({
    required this.transformAnimation,
    required this.width,
    required this.transformDayNightDistance,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: transformAnimation,
      builder: (context, child) {
        return Positioned(
          left: width * (43 / 369),
          bottom: width * (23 / 369) +
              transformDayNightDistance -
              transformAnimation.value,
          child:
              SvgPicture.asset(Assets.nightStars, width: width * (142 / 369)),
        );
      },
    );
  }
}
