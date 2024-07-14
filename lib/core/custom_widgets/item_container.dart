import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/user_provider.dart';

class ItemContainer extends ConsumerWidget {
  const ItemContainer({
    super.key,
    required this.userUid,
    required this.name,
    required this.description,
    required this.information,
    required this.imagePath,
    required this.price,
    required this.network,
    required this.itemId,
  });

  final String name;
  final String userUid;
  final String price;
  final String description;
  final String information;
  final String imagePath;
  final bool network;
  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(userProvider).likedAds.contains(itemId);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      // height: height * 0.26,
      width: width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (Theme.of(context).brightness == Brightness.light) ? Colors.white : Colors.grey[800],
        boxShadow: [
          (Theme.of(context).brightness == Brightness.light)
              ? BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              : const BoxShadow()
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.14,
            width: width * 0.4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  log('some error occured at item container $error');
                  return const Center(
                    child: Text(
                      'Image not found',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 3),
            height: height * 0.1,
            width: width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 17, bottom: 4),
                      child: Text(
                        '₹ $price',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    (ref.read(userProvider).userUid != userUid)
                        ? SizedBox(
                            height: 18,
                            child: Icon(
                              (isFav) ? Icons.favorite : Icons.favorite_border_sharp,
                              color: (isFav) ? Colors.red : Colors.grey,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
