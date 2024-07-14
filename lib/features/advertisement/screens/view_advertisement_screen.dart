import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/advertisement_provider.dart';
import 'package:seller_app/core/Providers/current_screen_provider.dart';
import 'package:seller_app/core/Providers/is_loading_provider.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/core/constants.dart';
import 'package:seller_app/features/advertisement/add_controller/add_controller.dart';
import 'package:seller_app/features/advertisement/screens/edit_ad_screen.dart';
import 'package:seller_app/features/chat/chat_controller/chat_controller.dart';
import 'package:seller_app/features/liked_items/controller/liked_item_controller.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/features/chat/chat_screens/chatting_screen.dart';
import 'package:seller_app/services/storage_services.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/datetime_convet.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class DisplayItemScreen extends ConsumerStatefulWidget {
  const DisplayItemScreen({
    super.key,
    required this.displayName,
    this.imagesInUint8,
    this.networkImages,
    required this.isPosted,
    this.model,
    required this.isUpdating,
  });
  final bool isPosted;
  final bool isUpdating;
  final List<Uint8List>? imagesInUint8; // updating images
  final List<String>? networkImages; // updating images
  final AdvertisementModel? model;
  final String displayName;

  @override
  ConsumerState<DisplayItemScreen> createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends ConsumerState<DisplayItemScreen> {
  List<String>? downloadableImageUrls;
  List<String> updatedImageDownloadUrls = [];
  List<Uint8List> selectedUint8Imageslist = [];

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List<Widget> buildImageSliders() {
      List<Widget> imageSliders = [];
      if (widget.networkImages != null) {
        log('1st');
        imageSliders.addAll(widget.networkImages!.map((item) {
          if (widget.isUpdating) {
            updatedImageDownloadUrls.add(item);
          }
          return Container(
            height: height * 0.34,
            width: width * 0.74,
            color: const Color.fromARGB(255, 239, 234, 216),
            child: Center(
              child: Image.network(
                item,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/login.png");
                },
              ),
            ),
          );
        }));
      }
      // when posting add
      if (widget.imagesInUint8 != null) {
        log('2nd');

        imageSliders.addAll(widget.imagesInUint8!.map((item) {
          if (widget.isUpdating) {
            selectedUint8Imageslist.add(item);
          }
          return Container(
            height: height * 0.34,
            width: width * 0.74,
            color: const Color.fromARGB(255, 239, 234, 216),
            child: Center(
              child: Image.memory(
                item,
                fit: BoxFit.contain,
              ),
            ),
          );
        }));
      }
      // when viewing add from feed/myads
      if (widget.model != null && widget.model!.photoUrl.isNotEmpty) {
        log('3rd');
        imageSliders.addAll(widget.model!.photoUrl.map((modelImage) {
          log('3rd inside map');
          return Container(
            height: height * 0.34,
            width: width * 0.74,
            color: const Color.fromARGB(255, 239, 234, 216),
            child: Center(
              child: Image.network(
                modelImage,
                fit: BoxFit.contain,
              ),
            ),
          );
        }));
      }
      log('fun imagesliders len ${imageSliders.length}');
      return imageSliders;
    }

    List<Widget> widgetimageSliders = buildImageSliders();
    log('image sliders${widgetimageSliders.length}');

    final currentUserProvider = ref.watch(userProvider);
    final advertisementState = ref.watch(advertisementProvider);
    return Scaffold(
      appBar: (!widget.isPosted)
          ? AppBar(
              title: const Text('Advertisement'),
            )
          : (widget.model!.userUid == ref.read(userProvider).userUid)
              ? AppBar(
                  title: const Text('Your advertisement'),
                  actions: [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAdvertisement(
                                advertisementModel: widget.model,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return {'Edit'}.map(
                          (String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          },
                        ).toList();
                      },
                    ),
                  ],
                )
              : AppBar(
                  title: const Text('Advertisement'),
                ),
      body: Stack(
        children: [
          Column(
            children: [
              if (widgetimageSliders.length > 1)
                CarouselSlider(
                  options: CarouselOptions(
                    height: height * 0.34,
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 7),
                  ),
                  items: widgetimageSliders,
                )
              else
                Container(
                  height: height * 0.34,
                  width: width * 0.74,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: Center(
                    child: widgetimageSliders.isNotEmpty ? widgetimageSliders[0] : const Text('No images available'),
                  ),
                ),

              SizedBox(height: height * 0.038),

              // item details container
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 50, 20, 0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isPosted ? widget.model!.name : advertisementState.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.isPosted ? '₹ ${widget.model!.price}' : advertisementState.price,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            (widget.isPosted && ref.watch(userProvider).userUid != widget.model!.userUid)
                                ? SizedBox(
                                    child: IconButton(
                                      onPressed: () {
                                        changeHeart(ref);
                                      },
                                      icon: (ref.watch(userProvider).likedAds.contains(widget.model?.itemId))
                                          ? const Icon(
                                              size: 28,
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              size: 28,
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: height * 0.018),
                        Text(
                          widget.isPosted ? widget.model!.description : advertisementState.description,
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
                                    ? NetworkImage(widget.model!.profilePhotoUrl.toString()) as ImageProvider
                                    : const AssetImage(Constants.maleProfilePic)
                                // add is not posted means it is in sell item page or my ads
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
          (isLoading)
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: (widget.isPosted && widget.model!.userUid != currentUserProvider.userUid)
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
          : (widget.isPosted)
              // this is when the ad is either ours(my ads) or not posted(in process of sell)
              ? Container()
              : SizedBox(
                  //ad is in process of sell(sell item)
                  height: 50,
                  width: width * 0.9,
                  child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      if (widget.isUpdating) {
                        updateAdd();
                      } else {
                        uploadAdvertisementToFirestore(ref);
                      }
                    },
                    child: const Text(
                      'post advertisement',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
    );
  }

  initiateChat(WidgetRef ref) async {
    await ref.watch(chatControllerProvider).initiateChat(
          widget.model!.userUid,
          ref.read(userProvider).userUid,
          widget.model!.itemId,
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
  uploadAdvertisementToFirestore(WidgetRef ref) {
    // uploading post data to firebase
    // if (downloadableImageUrls != null && downloadableImageUrls!.isNotEmpty ) {
    //   postAdvertisement(ref);
    // } else {
    //   log('wait a minute');
    //   // showSnackBar(context: context, message: 'Wait a minute..');
    // }
    postAdvertisement(ref);
  }

  changeHeart(WidgetRef ref) {
    log('change heart called');
    final condition = ref.read(userProvider).likedAds.contains(widget.model?.itemId);
    if (condition) {
      // item id is in the likeditems
      // currently item is fav
      // so, remove it from likedAds
      showAlertDialog(context, () {
        ref.read(likedItemControllerProvider).removeLikedItem(widget.model!.itemId);
        Navigator.pop(context);
      }, "Remove from liked items?");
    } else {
      // item is not in the likeditems
      // currently item is not fav
      // so, removee it from likedAds
      log('false, add it');
      ref.read(likedItemControllerProvider).addLikedItem(widget.model!.itemId);
    }
  }

  postAdvertisement(WidgetRef ref) async {
    log('post ad started');
    ref.read(isLoadingProvider.notifier).state = true;
    await convertToDownloadableUrls();
    String timestamp = DateAndTime().convertToTime(Timestamp.now());
    final advertisementState = ref.watch(advertisementProvider);
    final userDetails = ref.read(userProvider);
    // creating itemId
    // itemId - itemNameInitial+price+userUid
    String itemId = advertisementState.name[0] + advertisementState.price + ref.read(userProvider).userUid;

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

    uploadToDatabase(model, itemId);

    ref.read(advertisementProvider.notifier).clearState();

    ref.read(isLoadingProvider.notifier).state = false;

    ref.read(currentScrrenIndexProvider.notifier).state = 2;
    log('post ad ended');
  }

  uploadToDatabase(AdvertisementModel model, String itemId) {
    // uploading add to database
    ref.read(advertisementControllerProvider).postAdvertisement(sellItemModel: model, docId: itemId, context: context);
  }

  updateAdd() async {
    log('updating the add');
    ref.read(isLoadingProvider.notifier).state = true;
    final addController = ref.read(advertisementControllerProvider);
    final advertisementState = ref.read(advertisementProvider);

    log('selecteduint8imglist img len ${selectedUint8Imageslist.length}');
    // Convert all images into downloadable format
    await convertToDownloadableUrlsForUpdation(selectedUint8Imageslist);

    log('updatedImgdownurls list img len ${updatedImageDownloadUrls.length}');
    // Remove duplicates
    List<String> uniqueUpdatedImageDownloadUrls = updatedImageDownloadUrls.toSet().toList();
    log('updatedImgdownurls set img len ${updatedImageDownloadUrls.length}');

    // Update the advertisement
    addController.updateAdvertisement(
      itemId: advertisementState.itemId,
      newPrice: advertisementState.price,
      newName: advertisementState.name,
      description: advertisementState.description,
      photoUrls: uniqueUpdatedImageDownloadUrls,
    );

    updatedImageDownloadUrls.clear();
    selectedUint8Imageslist.clear();
    uniqueUpdatedImageDownloadUrls.clear();

    ref.read(isLoadingProvider.notifier).state = false;

    ref.read(currentScrrenIndexProvider.notifier).state = 2;
  }

  // fun to convert list of uint8list to list of downloadableurl
  Future<void> convertToDownloadableUrls() async {
    List<String> downloadUrls = [];
    if (widget.imagesInUint8 != null && widget.imagesInUint8!.isNotEmpty) {
      final addState = ref.watch(advertisementProvider);
      log('item id in convertToDownloadable${addState.itemId}');
      for (var image in widget.imagesInUint8!) {
        String downloadUrl = await StorageServices().getDownloadURLs(image, addState.itemId);
        downloadUrls.add(downloadUrl);
      }
    } else {
      showSnackBar(context: context, message: 'Empty images');
    }
    downloadableImageUrls = downloadUrls;
  }

  Future<void> convertToDownloadableUrlsForUpdation(List<Uint8List> uint8images) async {
    // Create a copy of the list to avoid concurrent modification
    List<Uint8List> imagesCopy = List<Uint8List>.from(uint8images);

    // Temporary list to hold download URLs
    List<String> tempUrls = [];

    for (var element in imagesCopy) {
      final downloadUrl = await StorageServices().getDownloadURLs(element, ref.read(advertisementProvider).itemId);
      tempUrls.add(downloadUrl);
    }

    // Add the URLs to the original list after the iteration
    updatedImageDownloadUrls.addAll(tempUrls);
  }
}
