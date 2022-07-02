import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void commonToast({
  required BuildContext context,
  required String msg,
  Color color = Colors.green,
  StyledToastPosition position = StyledToastPosition.bottom,
  Function? onDismiss,
  Function? onTap,
  double positionFromBottom = 0,
  Duration duration = const Duration(seconds: 3),
  StyledToastAnimation animation = StyledToastAnimation.fade,
  textColor = Colors.white,
}) {
  showToastWidget(
    Container(
      margin: EdgeInsets.only(bottom: positionFromBottom),
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap();
            ToastManager().dismissAll(showAnim: false);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            msg,
            style: TextStyle(
              color: textColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
    context: context,
    animation: animation,
    position: position,
    reverseAnimation: animation,
    duration: duration,
    isIgnoring: onTap == null ? true : false,
    onDismiss: () {
      if (onDismiss != null) onDismiss();
    },
  );
}
