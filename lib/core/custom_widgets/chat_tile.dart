import 'package:flutter/material.dart';

Container chatLeadingImage(BuildContext context, String itemImageUrl) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Container(
    color: Colors.grey[700],
    height: height * 0.15,
    width: width * 0.15,
    child: Image.network(
      itemImageUrl,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text('Image not found'),
        );
      },
    ),
  );
}
