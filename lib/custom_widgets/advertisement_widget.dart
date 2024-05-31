import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/main.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/screens/chatting_screen.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/services/authentication/firebase_storage_methods.dart';
import 'package:seller_app/utils/datetime_convet.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class DisplayItemScreen extends ConsumerStatefulWidget {
  const DisplayItemScreen(
      {super.key, this.imagesInUint8, required this.isPosted, this.model});
  final bool isPosted;
  final List<Uint8List>? imagesInUint8;
  final AdvertisementModel? model;

  @override
  ConsumerState<DisplayItemScreen> createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends ConsumerState<DisplayItemScreen> {
  List<String>? downloadableImageUrls;

  @override
  void initState() {
    if (!widget.isPosted) {
      convertToDownloadableUrls();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final advertisementState = ref.watch(advertisementProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CarouselSlider.builder(
                options: CarouselOptions(
                  height: height * 0.34,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 8),
                ),
                itemCount: (widget.isPosted)
                    ? widget.model!.photoUrl.length
                    : widget.imagesInUint8!.length,
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
                          child: (widget.isPosted)
                              ? Image.network(
                                  widget.model!.photoUrl[index],
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                        "assets/images/login.png");
                                  },
                                )
                              : Image.memory(
                                  widget.imagesInUint8![index],
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
                                border: Border.all(
                                    color: Colors.black, width: 0.5)),
                            child: Text(
                              widget.isPosted
                                  ? '${index + 1}/${widget.model!.photoUrl.length}'
                                  : '${index + 1}/${widget.imagesInUint8!.length}',
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
                        widget.isPosted
                            ? widget.model!.name
                            : advertisementState.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                          widget.isPosted
                              ? '₹ ${widget.model!.price}'
                              : advertisementState.price,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: height * 0.018),
                  Text(
                    widget.isPosted
                        ? widget.model!.description
                        : advertisementState.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: height * 0.05),

                  const Text(
                    'Posted by Some User',
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
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: width * 0.9,
        child: FloatingActionButton(
            onPressed: () {
              widget.isPosted ? makeOffer() : uploadAdvertisementToFirestore();
            },
            child: (widget.isPosted)
                ? const Text('Make An Offer')
                : const Text('Sell')),
      ),
    );
  }

  // chat with user and make offer
  makeOffer() {
    // TODO add current user to the user who is uploading the advertisement
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChattingScreen(receiverUserId: 'receiverUserId', receiverUsername: 'receiverUsername')));
  }

  // called when advertisement needs to be posted on firebase firestore
  uploadAdvertisementToFirestore() {
    // uploading post data to firebase
    if (downloadableImageUrls != null && downloadableImageUrls!.isNotEmpty) {
      postAdvertisement();
    } else {
      showSnackBar(context: context, message: 'Wait a minute..');
    }
  }

  postAdvertisement() async {
    String timestamp = DateAndTime().convertToTime(Timestamp.now());
    final advertisementState = ref.watch(advertisementProvider);

    // creating user model to display information to the displayitemscreen
    AdvertisementModel model = AdvertisementModel(
        timestamp: timestamp,
        userEmail: FirebaseAuth.instance.currentUser!.uid,
        name: advertisementState.name,
        description: advertisementState.description,
        photoUrl: downloadableImageUrls as List<String>,
        price: advertisementState.price);

    // navigate to advertisment screen after loading all download images

    // instamce of firebase storage
    final storage = FirebaseStorageMethods();

    // uploading data to database
    await APIs()
        .postAdvertisment(sellItemModel: model, docId: storage.userUid());

    //navigate to HomeScreen
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => const HomeScreen())),
        (route) => false);
  }

  // fun to convert list of uint8list to list of downloadableurl
  Future<void> convertToDownloadableUrls() async {
    List<String> downloadUrls = [];
    if (widget.imagesInUint8 != null && widget.imagesInUint8!.isNotEmpty) {
      for (var image in widget.imagesInUint8!) {
        String downloadUrl =
            await FirebaseStorageMethods().getDownloadURLs(image);
        downloadUrls.add(downloadUrl);
      }
    } else {
      showSnackBar(context: context, message: 'Empty images of uint8list');
    }
    downloadableImageUrls = downloadUrls;
  }
}
