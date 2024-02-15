import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DotsLoading extends StatelessWidget {
  const DotsLoading({
    super.key,
    this.color,
    this.radius,
    this.numOfDots,
    this.animationDuration,
  });

  final Color? color;
  final double? radius;
  final int? numOfDots;
  final Duration? animationDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < (numOfDots ?? 3); i++)
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            width: (radius ?? 12.5) * 2,
            height: (radius ?? 12.5) * 2,
          ),
      ]
          .animate(
            interval: animationDuration ?? 200.ms,
            onPlay: (controller) {
              controller.repeat(
                period: (animationDuration ?? 200.ms) * (numOfDots ?? 3),
                reverse: true,
              );
            },
          )
          .scale(duration: animationDuration ?? 200.ms),
    );
  }
}
