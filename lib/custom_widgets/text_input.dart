import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final IconData icon;

  const TextInputField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscure,
      required this.icon});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscure,
      decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }
}
