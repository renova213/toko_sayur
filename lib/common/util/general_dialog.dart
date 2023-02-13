import 'package:flutter/material.dart';

class GeneralDialog {
  static void generalDialog(
      {required BuildContext context, required Widget screen}) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: screen,
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
