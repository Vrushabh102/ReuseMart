import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/advertisement_provider.dart';
import 'package:seller_app/core/custom_widgets/text_input.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';
import 'package:seller_app/features/advertisement/screens/pick_image_screen.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class SellScreen extends ConsumerStatefulWidget {
  const SellScreen({super.key});

  @override
  ConsumerState<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends ConsumerState<SellScreen> {
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter item details'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextInputField(
                  inputType: TextInputType.name,
                  controller: _itemNameController,
                  hintText: 'Name of Item',
                  obscure: false,
                  autofillHints: const [],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: 'Type description of item',
                    hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 10),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default border color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0), // Focused border color and width
                    ),
                  ),
                  controller: _descriptionController,
                  obscureText: false,
                  autofillHints: const [],
                  maxLines: null,
                  minLines: 1,
                ),
                const SizedBox(height: 20),
                TextInputField(
                  inputType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: _priceController,
                  hintText: 'Enter price',
                  obscure: false,
                  autofillHints: const [],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      checkDetails();
                    },
                    style: loginButtonStyle().copyWith(
                      minimumSize: MaterialStatePropertyAll(
                        Size(width * 0.9, height * 0.06),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkDetails() {
    final priceText = _priceController.text.trim();
    final numericRegex = RegExp(r'^[0-9]+$');
    if (priceText.isEmpty) {
      showSnackBar(context: context, message: 'Price cannot be empty');
      return;
    }
    if (!numericRegex.hasMatch(priceText)) {
      showSnackBar(context: context, message: 'Price should only contain numbers');
      return;
    }
    if (_itemNameController.text.isEmpty || _descriptionController.text.isEmpty || _priceController.text.isEmpty) {
      showSnackBar(context: context, message: 'Enter details');
    } else if (int.parse(priceText) < 100) {
      showSnackBar(context: context, message: 'Price should be atleast Rs.100');
    } else {
      // all details are filled
      addDetailsState();
    }
  }

  // fun to add details to the state
  void addDetailsState() {
    final provider = ref.watch(advertisementProvider.notifier);
    // make the first char capital
    final allLower = _itemNameController.text.toLowerCase();
    String filteredName = allLower[0].toUpperCase() + allLower.substring(1, allLower.length);
    provider.setValues(
      setName: filteredName,
      setDescription: _descriptionController.text.trim(),
      setPrice: _priceController.text.trim(),
    );

    log('add values at enter details screen ${ref.read(advertisementProvider).name}');

    // _itemNameController.clear();
    // _descriptionController.clear();
    // _priceController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectImageScreen(),
      ),
    );
  }
}
