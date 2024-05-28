import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/models/sell_item_model.dart';
import 'package:seller_app/screens/web_screen.dart';
import 'package:seller_app/screens/pick_image_screen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  bool showImage = false;
  List<Uint8List>? images = [];
  String? photoUrl;

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextInputField(
                    controller: _itemNameController,
                    hintText: 'Name of Item',
                    obscure: false,
                    autofillHints: const []),
                const SizedBox(
                  height: 20,
                ),
                TextInputField(
                    controller: _descriptionController,
                    hintText: 'Type description of item',
                    obscure: false,
                    autofillHints: const []),
                const SizedBox(height: 20),
                TextInputField(
                    controller: _priceController,
                    hintText: 'Enter price',
                    obscure: false,
                    autofillHints: const []),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      // add some data to the database for now
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectImageScreen()));
                
                    },
                    style: loginButtonStyle(),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    )),
                    
              ],
            ),
          ],
        ),
      ),
    );
  }
}
