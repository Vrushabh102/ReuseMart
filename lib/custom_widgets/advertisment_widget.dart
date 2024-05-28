import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DisplayItemScreen extends StatefulWidget {
  const DisplayItemScreen({super.key, required this.images});
  final List<Uint8List>? images;

  @override
  State<DisplayItemScreen> createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends State<DisplayItemScreen> {
  String itemName = 'Shoes';
  String description =
      'Nike Dri-Fit is a polyester  fabric designed to help you keep dry so you can more comfortably work harder, longer.';
  String price = 'Rs.1000';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview your add'),
      ),
      body: Column(
        children: [
          CarouselSlider.builder(
              options: CarouselOptions(
                height: height * 0.34,
                initialPage: 0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 8),
              ),
              itemCount: widget.images!.length,
              itemBuilder:
                  (BuildContext context, int index, int pageViewIndex) {
                return Container(
                  height: height * 0.34,
                  width: width * 0.74,
                  color: const Color.fromARGB(255, 239, 234, 216),
                  child: Stack(
                    children: [
                      // 1st widget in stack - image
                      Center(
                        child: Image.memory(
                          widget.images![index],
                          fit: BoxFit.contain,
                        ),
                      ),
                      // 2nd widget in stack - main indicator
                      Positioned(
                        left: 10,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5)),
                          child: Text(
                            '${index + 1}/${widget.images!.length}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

          // item details container
          SizedBox(height: height * 0.038),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 50, 50, 0),
            height: height * 0.517,
            width: width * 0.96,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 0.5,
                  offset: const Offset(0, -1),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // item name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(price, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: height * 0.05),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: height * 0.018),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13),
                ),
                SizedBox(height: height * 0.05),

                const Text(
                  'Posted by chems baburao',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: width * 0.9,
        child: FloatingActionButton(
          onPressed: () {
            
          },
          child: const Text('Make An Offer'),
        ),
      ),
    );
  }
}
