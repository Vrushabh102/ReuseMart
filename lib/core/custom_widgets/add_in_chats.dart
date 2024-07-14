import 'package:flutter/material.dart';

Container addViewInChat({
  required String itemName,
  required String imageUrl,
  required String price,
  required String sellerName,
  required BuildContext context,
}) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Container(
    height: height * 0.1,
    width: width * 0.92,
    color: Colors.grey[800],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.values[4],
      children: [
        Image.network(
          imageUrl,
          height: height * 0.1,
        ),
        Column(
          children: [
            Text(
              itemName,
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 1),
            ),
          ],
        ),
      ],
    ),
  );
}
