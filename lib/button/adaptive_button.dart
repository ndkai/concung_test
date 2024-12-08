import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import 'models.dart';

class AdaptiveButton extends StatefulWidget {
  final double width;
  final Duration changeDayDuration;
  final DayType initType;

  const AdaptiveButton(
      {super.key,
      this.width = 300,
      required this.changeDayDuration,
      this.initType = DayType.morning});

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton>
    with TickerProviderStateMixin {
  // Constants for scaling and layout
  final double scaleFactor = 2.5; // Determines height-to-width ratio
  final double width = 500; // Default width of the button

  // Calculated layout properties
  late double height;
  late double padding;
  late double transformDayNightDistance;

  // Animation controllers and animations
  late AnimationController _hoverAnimationController;
  late Animation<double> _hoverAnimation;

  late AnimationController _hoverNightAnimationController;
  late Animation<double> _hoverNightAnimation;

  late AnimationController _changeDayAnimationController;
  late Animation<double> _changeDayAnimation;

  // State to determine if it's "day" or "night"
  bool isDay = true;

  @override
  void initState() {
    super.initState();

    // Calculate dimensions based on width and scale factor
    height = width / scaleFactor;
    padding = width * (12.5 / 369);
    transformDayNightDistance = width - 2 * padding - height * (120 / 145);

    // Initialize animations
    _initHoverAnimation();
    _initHoverNightAnimation();
    _initClickAnimation();
  }

  void _initHoverAnimation() {
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hoverAnimation =
        Tween<double>(begin: 1, end: 10).animate(_hoverAnimationController);
  }

  void _initHoverNightAnimation() {
    _hoverNightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hoverNightAnimation = Tween<double>(begin: 1, end: 30)
        .animate(_hoverNightAnimationController);
  }

  void _initClickAnimation() {
    _changeDayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _changeDayAnimation =
        Tween<double>(begin: 0, end: transformDayNightDistance)
            .animate(_changeDayAnimationController);
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    _hoverNightAnimationController.dispose();
    _changeDayAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
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
            _buildCloudFront(),
            _buildBackCloud(),
            _buildRays(),
            _buildSunAndMoon(),
            _buildStars(),
            // _buildMoon(),
          ],
        ),
      ),
    );
  }

  // Builds the sun widget with hover and click animations
  Widget _buildSunAndMoon() {
    double size = height * (120 / 145);

    return AnimatedBuilder(
      animation: Listenable.merge([_hoverAnimation, _changeDayAnimation]),
      builder: (context, child) {
        return Positioned(
          left: padding + _hoverAnimation.value + _changeDayAnimation.value,
          top: padding,
          child: Visibility(
            visible: true,
            child: MouseRegion(
              onEnter: (_) => _hoverAnimationController.forward(),
              onExit: (_) => _hoverAnimationController.reverse(),
              child: GestureDetector(
                onTap: () {
                  _changeDayAnimationController.forward().then((_) {
                    setState(() {
                      isDay = false;
                    });
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Stack(
                    children: [
                      SvgPicture.asset(Assets.daySun, height: size),
                      AnimatedBuilder(animation: Listenable.merge([_changeDayAnimation, _hoverNightAnimation]), builder: (context, chld){
                        return Positioned(
                          left: size * 1.5 -
                              size * 1.5 * _changeDayAnimationController.value,
                          child: MouseRegion(
                            onEnter: (_) => _hoverNightAnimationController.forward(),
                            onExit: (_) => _hoverNightAnimationController.reverse(),
                            child: GestureDetector(
                              onTap: () {
                                _changeDayAnimationController.reverse().then((_) {
                                  setState(() {
                                    isDay = true;
                                  });
                                });
                              },
                              child: SvgPicture.asset(Assets.nightMoon, height: size),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Builds the moon widget with hover and click animations
  Widget _buildMoon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_changeDayAnimation, _hoverNightAnimation]),
      builder: (context, child) {
        return Positioned(
          right: padding + _hoverNightAnimation.value,
          top: padding,
          child: Visibility(
            visible: _changeDayAnimationController.value == 1,
            child: MouseRegion(

              child: GestureDetector(
                onTap: () {
                  _changeDayAnimationController.reverse().then((_) {
                    setState(() {
                      isDay = true;
                    });
                  });
                },
                child: SvgPicture.asset(Assets.nightMoon,
                    height: height * (120 / 145)),
              ),
            ),
          ),
        );
      },
    );
  }

  // Builds the stars animation widget
  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _changeDayAnimation,
      builder: (context, child) {
        return Positioned(
          left: width * (43 / 369),
          bottom: width * (23 / 369) +
              transformDayNightDistance -
              _changeDayAnimation.value,
          child:
              SvgPicture.asset(Assets.nightStars, width: width * (142 / 369)),
        );
      },
    );
  }

  // Builds the front cloud animation
  Widget _buildCloudFront() {
    return AnimatedBuilder(
      animation: Listenable.merge([_changeDayAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Positioned(
          bottom: -_hoverAnimation.value - _changeDayAnimation.value,
          left: padding,
          child: SvgPicture.asset(Assets.dayClouds, width: width * (386 / 369)),
        );
      },
    );
  }

  // Builds the back cloud animation
  Widget _buildBackCloud() {
    return AnimatedBuilder(
      animation: Listenable.merge([_changeDayAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Positioned(
          bottom: -_hoverAnimation.value - _changeDayAnimation.value,
          left: 0,
          child: SvgPicture.asset(Assets.dayCloudsbacks,
              width: width * (377 / 369)),
        );
      },
    );
  }

  // Builds the sun rays animation
  Widget _buildRays() {
    double size = height * (368 / 145);
    double marginAll = -(size - height) / 2;

    return AnimatedBuilder(
      animation: Listenable.merge([_hoverAnimation, _changeDayAnimation]),
      builder: (context, child) {
        return Positioned(
          top: marginAll,
          left: marginAll + _hoverAnimation.value + _changeDayAnimation.value,
          child: SvgPicture.asset(Assets.dayRays, height: size, width: size),
        );
      },
    );
  }
}
