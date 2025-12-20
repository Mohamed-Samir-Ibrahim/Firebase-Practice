import 'package:firebase_practice/core/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.onChanged,
    this.obscureText,
    required this.validator,
    required this.hintText,
    this.initialValue,
  });

  final void Function(String)? onChanged;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final String hintText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: textInputDecoration.copyWith(hintText: hintText),
      validator: validator,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
    );
  }
}
