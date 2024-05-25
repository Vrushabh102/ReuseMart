import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final List<String> autofillHints;
  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.autofillHints,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: widget.autofillHints,
      controller: widget.controller,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
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
