import 'package:flutter/material.dart';
import 'package:seller_app/utils/colors.dart';

class MainIndicatorBox extends StatelessWidget {
  const MainIndicatorBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      width: 40,
      child: const Center(child: Text('Main')),
    );
  }
}
