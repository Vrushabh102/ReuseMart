import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/custom_widgets/advertisement_widget.dart';
import 'package:seller_app/custom_widgets/item_container.dart';
import 'package:seller_app/main.dart';
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
    final advertisementList = ref.watch(futureFeedAdvertisementsProvider);
    final height = MediaQuery.of(context).size.height;
    final currentUser = FirebaseAuth.instance.currentUser;

    return advertisementList.when(
      data: (data) {
        if (data.isNotEmpty) {
          // storing the list received from future provider
          feedAdvertisement.addAll(data);
          return Scaffold(
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: height * 0.27,
              ),
              itemCount: feedAdvertisement.length,
              itemBuilder: (context, index) {
                AdvertisementModel advertisementModel =
                    feedAdvertisement[index];
                // dont show current user ads on homepage
                if (advertisementModel.userUid != currentUser!.uid) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayItemScreen(
                                displayName: data[index].displayName,
                                isPosted: true,
                                model: advertisementModel),
                          ),
                        );
                      },
                      child: ItemContainer(
                        price: advertisementModel.price,
                        name: advertisementModel.name,
                        information: advertisementModel.timestamp,
                        description: advertisementModel.description,
                        imagePath: advertisementModel.photoUrl[0],
                        isFavorite: true,
                        network: true,
                      ),
                    ),
                  );
                } else {
                  return null;
                }
              },
            ),
          );
        } else {
          return const Center(
            child: Text('No Advertisements for now....',
                style: TextStyle(fontSize: 20)),
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
          child: Text('some error occured....$error',
              style: const TextStyle(fontSize: 20)),
        );
      },
    );
  }
}

/*
FutureBuilder(
          future: APIs().fetchFeedAdvertisements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (feedAdvertisement.isEmpty) {
                return const Center(
                  child:
                      Text('No adds for now', style: TextStyle(fontSize: 20)),
                );
              }
               return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: height * 0.26),
                itemCount: feedAdvertisement.length,
                itemBuilder: (context, index) {
                  AdvertisementModel advertisementModel =
                      feedAdvertisement[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayItemScreen(
                                    displayName: 'displayNameHomeScreen',
                                    isPosted: true,
                                    model: advertisementModel)));
                      },
                      child: ItemContainer(
                          price: advertisementModel.price,
                          name: advertisementModel.name,
                          information: advertisementModel.timestamp,
                          description: advertisementModel.description,
                          imagePath: advertisementModel.photoUrl[0],
                          isFavorite: true,
                          network: true),
                    ),
                  );
                },
              );
            }
            if (!snapshot.hasData) {
              const Center(
                child: Text('No Advertisements For now',
                    style: TextStyle(fontSize: 20)),
              );
            }
            return const Center(
              child: Text('Patience bro....', style: TextStyle(fontSize: 20)),
            );
          },
        ),

*/