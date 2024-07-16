import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/firebase_providers.dart';
import 'package:seller_app/core/custom_widgets/item_container.dart';
import 'package:seller_app/features/advertisement/add_controller/add_controller.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';

class DisplayHomeScreen extends ConsumerStatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  ConsumerState<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends ConsumerState<DisplayHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final advertisementList = ref.watch(feedAdvertisementsStreamProvider);
    final height = MediaQuery.of(context).size.height;
    final currentUser = ref.read(firebaseAuthProvider).currentUser;

    return Scaffold(
      body: advertisementList.when(
        data: (data) {
          if (data.isNotEmpty) {
            final fileteredData = data.where((ad) => ad.userUid != currentUser!.uid).toList();
            log('length of ads in home screen ${data.length}');
            log('length filtered in home screen ${fileteredData.length}');
            // storing the list received from future provider
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: height * 0.27,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: fileteredData.length,
                itemBuilder: (context, index) {
                  // Check if the current ad is posted by the current user
                    // Otherwise, show the ad
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              isUpdating: false,
                              displayName: fileteredData[index].displayName,
                              isPosted: true,
                              model: fileteredData[index],
                            ),
                          ),
                        );
                      },
                      child: ItemContainer(
                        userUid: fileteredData[index].userUid,
                        itemId: fileteredData[index].itemId,
                        price: fileteredData[index].price,
                        name: fileteredData[index].name,
                        information: fileteredData[index].timestamp,
                        description: fileteredData[index].description,
                        imagePath: fileteredData[index].photoUrl[0],
                        network: true,
                      ),
                    );
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
