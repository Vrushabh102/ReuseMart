import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/advertisement_provider.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/core/custom_widgets/text_input.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';
import 'package:seller_app/features/advertisement/screens/pick_image_screen.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class EditAdvertisement extends ConsumerStatefulWidget {
  const EditAdvertisement({required this.advertisementModel, super.key});
  final AdvertisementModel? advertisementModel;

  @override
  ConsumerState<EditAdvertisement> createState() => _EditAdvertisementState();
}

class _EditAdvertisementState extends ConsumerState<EditAdvertisement> {
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
  void initState() {
    _itemNameController.text = widget.advertisementModel!.name;
    _descriptionController.text = widget.advertisementModel!.description;
    _priceController.text = widget.advertisementModel!.price;
    super.initState();
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
                  decoration: const InputDecoration(
                    hintText: 'Type description of item',
                    hintStyle: TextStyle(fontWeight: FontWeight.w300),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default border color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0), // Focused border color and width
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
                ElevatedButton(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkDetails() {
    if (_itemNameController.text.isEmpty || _descriptionController.text.isEmpty || _priceController.text.isEmpty) {
      showSnackBar(context: context, message: 'Enter details');
    } else {
      // all details are filled
      addDetailsState();
    }
  }

  // fun to add details to the state
  void addDetailsState() {
    final provider = ref.watch(advertisementProvider.notifier);

    // set the item id to be able to update the advertisement
    ref.read(advertisementProvider.notifier).setAdvertisementId(itemId: widget.advertisementModel!.name + widget.advertisementModel!.price + ref.read(userProvider).userUid);

    

    provider.setValues(
      setName: _itemNameController.text,
      setDescription: _descriptionController.text,
      setPrice: _priceController.text,
    );

    // _itemNameController.clear();
    // _descriptionController.clear();
    // _priceController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectImageScreen(
          postedImages: widget.advertisementModel!.photoUrl,
        ),
      ),
    );
  }
}
