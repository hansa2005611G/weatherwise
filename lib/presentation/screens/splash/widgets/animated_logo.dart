import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:  const Duration(seconds: 2),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves. linear,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin:  1.0,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:  Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.3),
                  blurRadius:  30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow:  [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors. black.withOpacity(0.1),
                        blurRadius:  20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Sun rays
                      ... List.generate(8, (index) {
                        final angle = (index * math.pi / 4);
                        return Transform.rotate(
                          angle: angle,
                          child:  Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 4,
                              height: 20,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      }),

                      // Cloud icon
                      const Center(
                        child: Icon(
                          Icons.cloud,
                          size: 70,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
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
}