import 'package:flutter/material.dart';

void goToScreenWithSlideTransition(
  BuildContext context,
  Widget screen, {
  Offset? beginOffset,
  Duration transitionDuration = const Duration(milliseconds: 300),
  Duration reverseTransitionDuration = const Duration(milliseconds: 300),
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
        // ScaffoldMessenger.of(ctx).removeCurrentSnackBar();

        final screenTransitionDirection =
            Directionality.of(ctx) == TextDirection.rtl ? -1.0 : 1.0;

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset ?? Offset(screenTransitionDirection, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    ),
  );
}
