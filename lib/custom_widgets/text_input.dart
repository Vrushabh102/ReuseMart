import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final List<String> autofillHints;
  final Function(String)? onSubmit;
  const TextInputField({
    super.key,
    this.onSubmit,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmit,
      autofillHints: autofillHints,
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 10),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey, width: 0.5), // Default border color
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.blue, width: 2.0), // Focused border color and width
        ),
      ),
    );
  }
}
