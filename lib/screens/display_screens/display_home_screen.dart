import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/custom_widgets/item_container.dart';
import 'package:seller_app/features/advertisement/add_controller/add_controller.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/models/advertisement_model.dart';

class DisplayHomeScreen extends ConsumerStatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  ConsumerState<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends ConsumerState<DisplayHomeScreen> {
  List<AdvertisementModel> feedAdvertisement = [];

  @override
  Widget build(BuildContext context) {
    final advertisementList = ref.watch(feedAdvertisementsStreamProvider);
    final height = MediaQuery.of(context).size.height;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: advertisementList.when(
        data: (data) {
          if (data.isNotEmpty) {
            // storing the list received from future provider
            feedAdvertisement.addAll(data);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: height * 0.27,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: feedAdvertisement.length,
                itemBuilder: (context, index) {
                  AdvertisementModel advertisementModel = feedAdvertisement[index];
                  // dont show current user ads on homepage
                  if (advertisementModel.userUid != currentUser!.uid) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              isUpdating: false,
                              displayName: data[index].displayName,
                              isPosted: true,
                              model: advertisementModel,
                            ),
                          ),
                        );
                      },
                      child: ItemContainer(
                        userUid: advertisementModel.userUid,
                        itemId: advertisementModel.itemId,
                        price: advertisementModel.price,
                        name: advertisementModel.name,
                        information: advertisementModel.timestamp,
                        description: advertisementModel.description,
                        imagePath: advertisementModel.photoUrl[0],
                        network: true,
                      ),
                    );
                  } else {
                    log('No ads everyting is null');
                    return null;
                  }
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Advertisements for now....',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        },
        loading: () {
          return const Center(
            child: Text('Patience bro....', style: TextStyle(fontSize: 20)),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Text('some error occured....$error', style: const TextStyle(fontSize: 20)),
          );
        },
      ),
    );
  }
}
