import 'package:evoting/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String?) validator;
  final TextInputType? textInputType;
  const CustomFormField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.validator,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType ?? TextInputType.text,
      onChanged: (val) {
        onChanged(val);
      },
      validator: (val) {
        return validator(val);
      },
      cursorColor: primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xffEDF2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
