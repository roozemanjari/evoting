import 'package:evoting/themes/colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String name;
  final Function onPressed;

  const SecondaryButton({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      onPressed: () {
        onPressed();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: primaryColor, width: 2),
      ),
      color: Colors.white,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Text(
        name.toUpperCase(),
        style: const TextStyle(
          color: primaryColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
