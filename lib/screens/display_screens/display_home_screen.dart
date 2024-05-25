import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/item_container.dart';

class DisplayHomeScreen extends StatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  State<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends State<DisplayHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const ItemContainer(
              titleText: 'keyboard',
              description: 'new mechanical keyboard with all keys, good rgb colors',
              information: '4hrs ago',
              imagePath:
                  'https://rukminim2.flixcart.com/image/850/1000/xif0q/keyboard/desktop-keyboard/w/l/6/gaming-keyboard-with-87-keys-rgb-backlit-with-suspension-keys-original-imagzcgwtrabgjna.jpeg?q=20&crop=false',
              network: true,
              backgroundColorHex: 0xFFFFFFFF,
            );
          },
        ),
      ),
    );
  }
}
