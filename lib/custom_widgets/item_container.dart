
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer(
      {super.key,
      required this.isFavorite,
      required this.name,
      required this.description,
      required this.information,
      required this.imagePath,
      required this.price,
      required this.network});

  final String name;
  final bool isFavorite;
  final String price;
  final String description;
  final String information;
  final String imagePath;
  final bool network;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.26,
      width: width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.1,
              blurRadius: 0.1,
              offset: Offset(0, -1),
            ),
          ]),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.14,
            width: width * 0.4,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
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
                      padding: const EdgeInsets.only(top: 17),
                      child: Text(
                        '₹ $price',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: IconButton(
                          onPressed: changeHeart(),
                          icon: (isFavorite)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                )),
                    ),
                  ],
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // function to change like or dislike
  changeHeart() {

  }
}
