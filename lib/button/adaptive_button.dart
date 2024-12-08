import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';

class AdaptiveButton extends StatefulWidget {
  const AdaptiveButton({super.key});

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late Animation<double> _hoverAnimation;

  late AnimationController _clickAnimationController;
  late Animation<double> _clickAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hoverAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _hoverAnimation =
        Tween<double>(begin: 1, end: 10).animate(_hoverAnimationController);
    _clickAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _clickAnimation =
        Tween<double>(begin: 1, end: 10).animate(_clickAnimationController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _hoverAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        _cloudFront(padding, height, width),
                        _cloudBack(padding, height, width),
                        _rays(padding, height, width),
                        _sun(padding, height),
                        // Positioned(
                        //   left: width * (43 / 369),
                        //   bottom: width * (23 / 369),
                        //   child: SvgPicture.asset(
                        //     Assets.nightStars,
                        //     width: width * (142 / 369),
                        //   ),
                        // ),
                        // Positioned(
                        //   right: 0,
                        //   top: 0,
                        //   child: SvgPicture.asset(
                        //     Assets.nightRays,
                        //     height: height,
                        //   ),
                        // ),
                        // Positioned(
                        //     right: padding,
                        //     top: padding,
                        //     child: SvgPicture.asset(
                        //       Assets.nightMoon,
                        //       height: height * 120 / 145,
                        //     )),
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _sun(double padding, double height) {
    return AnimatedBuilder(
      animation: _hoverAnimation, builder: (context, child) {
      return Positioned(
          left: padding + _hoverAnimation.value,
          top: padding,
          child: MouseRegion(
            onEnter: (event) {
              _hoverAnimationController.forward();

            },
            onExit: (event) {
              _hoverAnimationController.reverse();
            },
            child: SvgPicture.asset(
              Assets.daySun,
              height: height * 120 / 145,
            ),
          ));
    });
  }

  Widget _cloudFront(double padding, double height, double width) {
    return AnimatedBuilder(
        animation: _hoverAnimation, builder: (context, child) {
      return  Positioned(
        bottom: 0 - _hoverAnimation.value,
        left: padding,
        child: SvgPicture.asset(Assets.dayClouds,
            width: width * (386 / 369)),
      );
    });
  }

  Widget _cloudBack(double padding, double height, double width) {
    return AnimatedBuilder(
        animation: _hoverAnimation, builder: (context, child) {
      return  Positioned(
        top: 0 + _hoverAnimation.value,
        left: 0,
        child: SvgPicture.asset(
          Assets.dayCloudsbacks,
          width: width * (377 / 369),
        ),
      );
    });
  }

  Widget _rays(double padding, double height, double width) {
    return AnimatedBuilder(
        animation: _hoverAnimation, builder: (context, child) {
      return  Positioned(
        left: 0 + _hoverAnimation.value,
        top: 0,
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.nightRays,
              height: height,
            ),
            SvgPicture.asset(
              Assets.dayRays,
              height: height,
            )
          ],
        ),
      );
    });
  }
}
