import 'package:evoting/themes/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final bool isDisabled;

  const PrimaryButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      onPressed: () {
        if (!isDisabled) onPressed();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: primaryColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: child,
    );
  }
}
