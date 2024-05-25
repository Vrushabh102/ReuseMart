import 'package:flutter/material.dart';

const webScreenWidth = 600;

showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
