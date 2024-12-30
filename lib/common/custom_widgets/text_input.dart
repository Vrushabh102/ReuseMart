import 'package:flutter/material.dart';
import 'package:seller_app/utils/colors.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final List<String> autofillHints;
  final Function(String)? onSubmit;
  final TextInputType inputType;
  const TextInputField({
    super.key,
    this.onSubmit,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.autofillHints,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      onSubmitted: onSubmit,
      autofillHints: autofillHints,
      controller: controller,
      obscureText: obscure,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 10),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default border color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0), // Focused border color and width
        ),
      ),
    );
  }
}
