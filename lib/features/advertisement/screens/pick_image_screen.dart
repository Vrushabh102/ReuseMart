import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/providers/user_provider.dart';
import 'package:seller_app/common/custom_widgets/display_image.dart';
import 'package:seller_app/common/custom_styles/button_styles.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class SelectImageScreen extends ConsumerStatefulWidget {
  const SelectImageScreen({this.postedImages, super.key});
  final List<String>? postedImages;

  @override
  ConsumerState<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends ConsumerState<SelectImageScreen> {
  bool showImages = false;
  int mainImageIndex = 0;
  List<Uint8List>? uint8images = [];
  List<String>? networkImages = [];

  @override
  void initState() {
    networkImages = widget.postedImages;
    showImages = (networkImages != null && networkImages!.isNotEmpty) || (uint8images != null && uint8images!.isNotEmpty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = ref.watch(userProvider).fullName ?? 'No name';
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Images'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (showImages)
              ? Expanded(
                  child: GridView.builder(
                    itemCount: (uint8images?.length ?? 0) + (networkImages?.length ?? 0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      if (index < (networkImages?.length ?? 0)) {
                        // Display network images
                        return InkWell(
                          onLongPress: () => removeImage(index, true),
                          onTap: () {
                            setState(() {
                              mainImageIndex = index;
                            });
                          },
                          child: (index == mainImageIndex) ? CurrentDisplayImage(imageUrl: networkImages![index]) : DisplayImage(imageUrl: networkImages![index]),
                        );
                      } else {
                        // Display new images
                        final newIndex = index - (networkImages?.length ?? 0);
                        return InkWell(
                          onLongPress: () => removeImage(newIndex, false),
                          onTap: () {
                            setState(() {
                              mainImageIndex = index;
                            });
                          },
                          child: (index == mainImageIndex) ? CurrentDisplayImage(image: uint8images![newIndex]) : DisplayImage(image: uint8images![newIndex]),
                        );
                      }
                    },
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Text(
                      'No Images Selected',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  style: loginButtonStyle().copyWith(
                    minimumSize: WidgetStatePropertyAll(Size(width * 0.9, height * 0.06)),
                  ),
                  onPressed: () async {
                    await selectImageScreen(context);
                    if (uint8images != null && uint8images!.isNotEmpty) {
                      viewImages();
                    }
                  },
                  child: ((uint8images == null || uint8images!.isEmpty) && (networkImages == null || networkImages!.isEmpty))
                      ? const Text(
                          'Select An Image',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Select Another Image',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              if (showImages)
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: loginButtonStyle().copyWith(
                      minimumSize: WidgetStatePropertyAll(Size(width * 0.9, height * 0.06)),
                    ),
                    onPressed: () async {
                      if ((uint8images != null && uint8images!.isNotEmpty) || (networkImages != null && networkImages!.isNotEmpty)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              isUpdating: (widget.postedImages != null),
                              displayName: displayName,
                              isPosted: false,
                              imagesInUint8: uint8images,
                              networkImages: networkImages,
                            ),
                          ),
                        );
                      }
                    },
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
    );
  }

  // fun to pick images from gallery
  selectImageScreen(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile>? imagesXFile = await imagePicker.pickMultiImage(
      imageQuality: 68,
    );
    if (imagesXFile.isNotEmpty) {
      for (var img in imagesXFile) {
        final currImg = await img.readAsBytes();
        if (!uint8images!.contains(currImg)) {
          uint8images!.add(currImg);
        }
      }
      setState(() {
        showImages = true;
      });
    } else {
      showSnackbar('No Image Selected');
    }
  }

  showSnackbar(String message) {
    showSnackBar(context: context, message: message);
  }

  // fun to view images to the screen
  viewImages() {
    setState(() {
      showImages = true;
    });
  }

  // fun to remove image when user longpress any image
  void removeImage(int index, bool isNetworkImage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 2,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Remove this Image?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (isNetworkImage) {
                    networkImages!.removeAt(index);
                  } else {
                    uint8images!.removeAt(index);
                  }
                  if ((networkImages == null || networkImages!.isEmpty) && (uint8images == null || uint8images!.isEmpty)) {
                    showImages = false;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
