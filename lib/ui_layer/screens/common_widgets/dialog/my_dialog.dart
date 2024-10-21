import 'package:flutter/material.dart';

class MyDialog {
  static Future<T?> showDialog<T extends Object?>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    bool needTransition = false,
  }) {
    return showGeneralDialog<T>(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      context: context,
      barrierDismissible: barrierDismissible,
      transitionBuilder: needTransition
          ? (context, a1, _, child) {
              var curve = Curves.easeInOut.transform(a1.value);
              return Transform.scale(
                scale: curve,
                child: child,
              );
            }
          : null,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return child;
      },
    );
  }
}
