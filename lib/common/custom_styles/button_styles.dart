import 'package:flutter/material.dart';

ButtonStyle loginButtonStyle() {
  return const ButtonStyle(
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
    elevation: WidgetStatePropertyAll(0),
    backgroundColor: WidgetStatePropertyAll(Color(0xff00c6a7)),
  );
}

BoxDecoration googleButtonDecoration() {
  return BoxDecoration(
    border: Border.all(color: const Color.fromARGB(255, 222, 220, 220)),
    borderRadius: BorderRadius.circular(14),
    color: Colors.white,
  );
}

ButtonStyle googleButtonStyle() {
  return const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Colors.white,
      ),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      )));
}
