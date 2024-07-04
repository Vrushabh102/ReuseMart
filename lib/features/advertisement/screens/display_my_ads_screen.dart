import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/advertisement_widget.dart';
import 'package:seller_app/custom_widgets/item_container.dart';
import 'package:seller_app/main.dart';
import 'package:seller_app/features/advertisement/screens/display_sell_screen.dart';
import 'package:seller_app/services/firestore_services.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class MyAdsScreen extends ConsumerWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ref.watch(userAdsProvider).when(
      data: (data) {
        if (data.isNotEmpty) {
          return Scaffold(
            body: SafeArea(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: height * 0.27,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 1,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final ad = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                              displayName: ad.displayName,
                              isPosted: true,
                              model: ad,
                            ),
                          ));
                    },
                    // to remove the add
                    onLongPress: () {
                      showAlertDialog(context, () {
                        log('deletion started');
                        FirestoreServices()
                            .deleteAdvertisementById(data[index].itemId);
                        Navigator.pop(context);
                      }, 'Do you want to delete this advertisement?');
                    },
                    child: ItemContainer(
                        isFavorite: false,
                        name: ad.name,
                        description: ad.description,
                        information: ad.timestamp,
                        imagePath: ad.photoUrl[0],
                        price: ad.price,
                        network: true),
                  );
                },
              ),
            ),
          );
        } else {
          // if there is no add.....
          return Scaffold(
            body: Center(
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
                      )),
                ],
              ),
            ),
          );
        }
      },
      error: (error, stackTrace) {
        log(error.toString());
        log(stackTrace.toString());
        return const Scaffold(
          body: Center(
            child: Text('Some error'),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
