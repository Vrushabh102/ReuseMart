import 'package:flutter/material.dart';

ButtonStyle loginButtonStyle() {
  return const ButtonStyle(
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)))),
    elevation: MaterialStatePropertyAll(0),
    backgroundColor: MaterialStatePropertyAll(Color(0xff00c6a7)),
  );
}

BoxDecoration googleButtonDecoration() {
  return BoxDecoration(
    border: Border.all(color: const Color.fromARGB(255, 222, 220, 220)),
    borderRadius: BorderRadius.circular(14),
  );
}

