import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/main_image_indicator.dart';

class DisplayImage extends StatelessWidget {
  final Uint8List image;
  const DisplayImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 239, 234, 216),
      margin: const EdgeInsets.all(5),
      height: 180,
      width: 180,
      child: Image.memory(image, fit: BoxFit.contain),
    );
  }
}

class CurrentDiaplayImage extends StatelessWidget {
  final Uint8List image;
  const CurrentDiaplayImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 234, 216),
          border: Border.all(color: primaryColor, width: 2.5),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      margin: const EdgeInsets.all(5),
      height: 180,
      width: 180,
      child: Stack(
        children: [
          // 1st widget in stack - image
          Center(
            child: Image.memory(image),
          ),
          // 2nd widget in stack - main indicator
          const Positioned(
            left: 25,
            top: 15,
            child: MainIndicatorBox(),
          )
        ],
      ),
    );
  }
}
