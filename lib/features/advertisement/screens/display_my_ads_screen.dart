import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/custom_widgets/item_container.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/features/advertisement/add_controller/add_controller.dart';
import 'package:seller_app/features/advertisement/screens/display_sell_screen.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class MyAdsScreen extends ConsumerWidget {
  const MyAdsScreen({super.key});

  deleteAdvertisement(BuildContext context, itemId, WidgetRef ref) {
    showAlertDialog(
      context,
      () {
        log('deletion started');
        ref.read(userPostedAdsProvider.notifier).deleteAdvertisementById(itemId);
        Navigator.pop(context);
      },
      'Do you want to delete this advertisement?',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Trigger loading ads when the widget is built
    final ads = ref.watch(userPostedAdsProvider);
    ref.read(userPostedAdsProvider.notifier).getAllAdsPostedByUser();

    return Scaffold(
      body: SafeArea(
        child: ads.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: height * 0.27,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              isUpdating: false,
                              displayName: ad.displayName,
                              isPosted: true,
                              model: ad,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        deleteAdvertisement(context, ad.itemId, ref);
                      },
                      child: ItemContainer(
                        userUid: ad.itemId,
                        itemId: ad.itemId,
                        name: ad.name,
                        description: ad.description,
                        information: ad.timestamp,
                        imagePath: ad.photoUrl[0],
                        price: ad.price,
                        network: true,
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Start selling now!',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SellScreen();
                          },
                        ));
                      },
                      style: loginButtonStyle().copyWith(
                        minimumSize: MaterialStatePropertyAll(
                          Size(width * 0.85, height * 0.06),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
