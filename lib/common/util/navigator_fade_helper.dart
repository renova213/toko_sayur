import 'package:flutter/material.dart';

class NavigatorFadeHelper extends PageRouteBuilder {
  final Widget child;
  NavigatorFadeHelper({required this.child})
      : super(
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
