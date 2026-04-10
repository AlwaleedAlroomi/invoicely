import 'package:flutter/material.dart';

class FadeThroughRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeThroughRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the entering animation (Fade + Scale)
          final fadeIn = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
          );

          final scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          // Define the outgoing animation (Fade)
          final fadeOut = CurvedAnimation(
            parent: secondaryAnimation,
            curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
          );

          return FadeTransition(
            opacity: fadeIn,
            child: ScaleTransition(
              scale: scaleIn,
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(fadeOut),
                child: child,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      );
}
