import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final IconData icon;
  final List<String> autofillHints;
  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.icon,
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
        prefixIcon: Icon(widget.icon),
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.green, width: 1.4)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
