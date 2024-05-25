import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/models/sell_item_model.dart';
import 'package:seller_app/utils/pick_image.dart';

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
  dynamic selectedImage;
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  selectedImage = await pickImage(ImageSource.gallery);
                  checkImage(selectedImage);
                },
                style: loginButtonStyle(),
                child: const Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  // add some data to the database for now
                  addDataToFirebase();
                },
                style: loginButtonStyle(),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 50),
            if (showImage)
              CircleAvatar(
                  radius: 100, backgroundImage: MemoryImage(selectedImage))
          ],
        ),
      ),
    );
  }

  checkImage(image) {
    log('check image started ${selectedImage.toString()}');
    if (image != null) {
      setState(() {
        showImage = true;
      });
    }
  }

  void addDataToFirebase() {
    SellItemModel itemModel = SellItemModel(
        title: _itemNameController.text,
        description: _descriptionController.text,
        photoUrl: 'some url',
        price: _priceController.text,
        showPersonalDetails: true);

    // save data to the firebase
    // saveItemData();
  }
}
