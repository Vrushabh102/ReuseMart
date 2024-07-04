import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/advertisement_widget.dart';
import 'package:seller_app/custom_widgets/display_image.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({super.key});

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  List<Uint8List>? images = [];
  bool showImages = false;
  int mainImageIndex = 0;
  List<String>? downloadableImageUrls;
  late String displayName;

  @override
  Widget build(BuildContext context) {
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
                      itemCount: images!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () => removeImage(index),
                          onTap: () {
                            setState(() {
                              mainImageIndex = index;
                            });
                          },
                          child: (index == mainImageIndex)
                              ? CurrentDiaplayImage(image: images![index])
                              : DisplayImage(image: images![index]),
                        );
                      }))
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
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: loginButtonStyle().copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(width * 0.9, height * 0.06),
                    ),
                  ),
                  onPressed: () async {
                    images = await selectImageScreen(context);
                    if (images != null && images!.isNotEmpty) {
                      viewImages();
                      getUserName();
                    }
                  },
                  child: (images == null || images!.isEmpty)
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
                      minimumSize: MaterialStatePropertyAll(
                        Size(width * 0.9, height * 0.06),
                      ),
                    ),
                    onPressed: () async {
                      if (images != null && images!.isNotEmpty && displayName.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              displayName: displayName,
                              isPosted: false,
                              imagesInUint8: images,
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
    List<XFile>? imagesXFile = await imagePicker.pickMultiImage();
    if (images != null) {
      // clearing global & local images list
      this.images!.clear();
      // adding images to the list
      List<Uint8List> images = [];
      for (var img in imagesXFile) {
        final currImg = await img.readAsBytes();
        images.add(currImg);
      }
      return images;
    }
    // no image is selected
    showSnackBar(context: context, message: 'No Image Selected');
  }

  // fun to view images to the screen
  viewImages() {
    setState(() {
      showImages = true;
    });
  }

  // fun to remove image when user longpress any image
  void removeImage(int index) {
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
                // remove the image from the list at index received
                setState(() {
                  images!.removeAt(index);
                  // check if all the images are deleted
                  if (images == null || images!.isEmpty) {
                    showImages = false;
                  }
                });
                Navigator.of(context).pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // do noting
                Navigator.of(context).pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> getUserName() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final fullname = data.data()!['fullname'] ?? 'Unknown';
    displayName = fullname;
  }
}
