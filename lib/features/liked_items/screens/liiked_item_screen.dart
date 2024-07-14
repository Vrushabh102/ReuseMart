import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/core/custom_widgets/item_container.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/features/liked_items/controller/liked_item_controller.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/utils/colors.dart';

class LikedItems extends ConsumerWidget {
  const LikedItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final likedItemsAsyncValue = ref.watch(likedItemsFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Items')),
      body: likedItemsAsyncValue.when(
        data: (likedItems) {
          if (likedItems.isEmpty) {
            return const Center(
                child: Text(
              'No liked items',
              style: TextStyle(fontSize: 18),
            ));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: height * 0.27,
              ),
              itemCount: likedItems.length,
              itemBuilder: (context, index) {
                AdvertisementModel advertisementModel = likedItems[index];
                // dont show current user ads on homepage
                if (advertisementModel.userUid != ref.read(userProvider).userUid) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              isUpdating: false,
                              displayName: likedItems[index].displayName,
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
                    ),
                  );
                } else {
                  log('No ads everyting is null');
                  return null;
                }
              },
            );
          }
        },
        loading: () => Center(
            child: CircularProgressIndicator(
          color: primaryColor,
        )),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
