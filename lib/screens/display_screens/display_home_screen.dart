import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/advertisement_widget.dart';
import 'package:seller_app/custom_widgets/item_container.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';

class DisplayHomeScreen extends StatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  State<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends State<DisplayHomeScreen> {
  @override
  void initState() {
    fetchFeedAdvertisment();
    super.initState();
  }

  List<AdvertisementModel> feedAdvertisement = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
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
      ),
    );
  }

  void fetchFeedAdvertisment() async {
    // fetching querysnapshot
    APIs firestore = APIs();
    final ads = await firestore.fetchFeedAdvertisements();

    // storing documents in variable
    final advertisements = ads.docs
        .map((e) => AdvertisementModel.fromSnapShot(
            e as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    if (advertisements.isNotEmpty) {
      feedAdvertisement.addAll(advertisements);
    }
  }
}
