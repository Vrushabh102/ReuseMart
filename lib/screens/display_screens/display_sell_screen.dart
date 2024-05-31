import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/main.dart';
import 'package:seller_app/screens/pick_image_screen.dart';
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
                      checkDetails();
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

  void checkDetails() {
    if (_itemNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      showSnackBar(context: context, message: 'Enter details');
    } else {
      // all details are filled
      addDetailsState();
    }
  }

  // fun to add details to the state
  void addDetailsState() {
    final provider = ref.watch(advertisementProvider.notifier);
    provider.setValues(
        setName: _itemNameController.text,
        setDescription: _descriptionController.text,
        setPrice: _priceController.text);

    _itemNameController.clear();
    _descriptionController.clear();
    _priceController.clear();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SelectImageScreen()));
  }
}
