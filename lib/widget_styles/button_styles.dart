import 'package:flutter/material.dart';

ButtonStyle loginButtonStyle() {
  return const ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      backgroundColor: MaterialStatePropertyAll(Colors.black),
      minimumSize: MaterialStatePropertyAll(Size(360, 50)));
}

ButtonStyle googleButtonStyle() {
  return const ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      backgroundColor: MaterialStatePropertyAll(Colors.black),
      minimumSize: MaterialStatePropertyAll(Size(360, 50)));
}