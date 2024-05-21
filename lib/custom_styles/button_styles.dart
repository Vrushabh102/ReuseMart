import 'package:flutter/material.dart';

ButtonStyle loginButtonStyle() {
  return const ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      backgroundColor: MaterialStatePropertyAll(Color(0xff00c6a7)),
      minimumSize: MaterialStatePropertyAll(Size(360, 50)));
}

ButtonStyle googleButtonStyle() {
  return const ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      backgroundColor: MaterialStatePropertyAll(Colors.black),
      minimumSize: MaterialStatePropertyAll(Size(360, 50)));
}
