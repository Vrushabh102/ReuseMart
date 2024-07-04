import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/core/constants.dart';
import 'package:seller_app/main.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/screens/chatting_screen.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/services/chat_services.dart';
import 'package:seller_app/services/firestore_services.dart';
import 'package:seller_app/services/storage_services.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/datetime_convet.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class DisplayItemScreen extends ConsumerStatefulWidget {
  const DisplayItemScreen({
    super.key,
    required this.displayName,
    this.imagesInUint8,
    required this.isPosted,
    this.model,
  });
  final bool isPosted;
  final List<Uint8List>? imagesInUint8;
  final AdvertisementModel? model;
  final String displayName;
  @override
  ConsumerState<DisplayItemScreen> createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends ConsumerState<DisplayItemScreen> {
  List<String>? downloadableImageUrls;

  @override
  void initState() {
    super.initState();
    if (!widget.isPosted) {
      convertToDownloadableUrls();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProvider = ref.watch(userProvider);
    final advertisementState = ref.watch(advertisementProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: (!widget.isPosted)
            ? AppBar(
                title: const Text('Advertisement'),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      log('clicked');
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Edit'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              )
            : EmptyAppbar(),
        body: Column(
          children: [
            (widget.isPosted
                    ? widget.model!.photoUrl.length > 1
                    : widget.imagesInUint8!.length > 1)
                ? CarouselSlider.builder(
                    options: CarouselOptions(
                      height: height * 0.34,
                      initialPage: 0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
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
                            // 2nd widget in stack - indicator
                            Positioned(
                              left: 10,
                              top: 12,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
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
                    },
                  )
                : SizedBox(
                    height: height * 0.34,
                    child: (widget.isPosted)
                        ? Image.network(
                            widget.model!.photoUrl[0],
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset("assets/images/login.png");
                            },
                          )
                        : Image.memory(
                            widget.imagesInUint8![0],
                            fit: BoxFit.contain,
                          ),
                  ),

            SizedBox(height: height * 0.038),
            // item details container
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 50, 50, 0),
                  // height: height * 0.57,
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

                      // user details who posted
                      const Text(
                        'Posted by',
                        style: TextStyle(fontSize: 16),
                      ),
                      ListTile(
                        style: ListTileStyle.list,
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(widget.displayName),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: (widget.isPosted)
                              ?
                              // add is posted, so model is not null
                              (widget.model?.photoUrl != null)
                                  ? NetworkImage(widget.model!.profilePhotoUrl
                                      .toString()) as ImageProvider
                                  : const AssetImage(
                                      Constants.maleProfilePic)
                              // add is not posted means it is in sell item page
                              : (currentUserProvider.photoUrl != null)
                                  ? NetworkImage(currentUserProvider.photoUrl.toString()) as ImageProvider
                                  : const AssetImage(
                                      Constants.maleProfilePic,
                                    ),
                          onBackgroundImageError: (exception, stackTrace) {
                            log('image exception $exception');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: (widget.isPosted &&
                widget.model!.userUid != currentUserProvider.userUid)
            ? SizedBox(
                height: 50,
                width: width * 0.9,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    makeOffer();
                  },
                  child: const Text('Make An Offer'),
                ),
              )
            : SizedBox(
                height: 50,
                width: width * 0.9,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    uploadAdvertisementToFirestore();
                  },
                  child: const Text('Post Advertisement'),
                ),
              ));
  }

  initiateChat(WidgetRef ref) async {
    await ChatServices().initiateChat(
      widget.model!.userUid,
      ref.read(userProvider).userUid,
      widget.model!.itemId,
      context,
    );
  }

  // chat with user and make offer
  makeOffer() {
    initiateChat(ref);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChattingScreen(
          isCurrentUserSelling: false,
          addmodel: widget.model as AdvertisementModel,
          userModel: null,
        ),
      ),
    );
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
    final userDetails = ref.read(userProvider);
    // creating itemId
    // itemId - itemNameInitial+price+userUid
    String itemId = advertisementState.name[0] +
        advertisementState.price +
        ref.read(userProvider).userUid;

    log(itemId);

    // creating user model to display information to the displayitemscreen
    AdvertisementModel model = AdvertisementModel(
      itemId: itemId,
      userUid: userDetails.userUid,
      displayName: widget.displayName,
      profilePhotoUrl: userDetails.photoUrl ?? Constants.maleProfilePic,
      timestamp: timestamp,
      name: advertisementState.name,
      description: advertisementState.description,
      photoUrl: downloadableImageUrls as List<String>,
      price: advertisementState.price,
    );

    // uploading data to database
    await FirestoreServices()
        .postAdvertisment(sellItemModel: model, docId: itemId);

    if (context.mounted) {
      //navigate to HomeScreen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: ((context) => const HomeScreen()),
          ),
          (route) => false);
    }
  }

  // fun to convert list of uint8list to list of downloadableurl
  Future<void> convertToDownloadableUrls() async {
    List<String> downloadUrls = [];
    if (widget.imagesInUint8 != null && widget.imagesInUint8!.isNotEmpty) {
      final addState = ref.watch(advertisementProvider);
      log('item id in convertToDownloadable${addState.itemId}');
      for (var image in widget.imagesInUint8!) {
        String downloadUrl =
            await StorageServices().getDownloadURLs(image, addState.itemId);
        downloadUrls.add(downloadUrl);
      }
    } else {
      showSnackBar(context: context, message: 'Empty images of uint8list');
    }
    downloadableImageUrls = downloadUrls;
  }
}
