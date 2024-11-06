import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/advertisement_provider.dart';
import 'package:seller_app/core/Providers/firebase_providers.dart';
import 'package:seller_app/core/custom_widgets/item_container.dart';
import 'package:seller_app/features/advertisement/add_controller/add_controller.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/utils/colors.dart';

class DisplayHomeScreen extends ConsumerStatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  ConsumerState<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends ConsumerState<DisplayHomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.text = ref.read(searchQueryProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final currentUser = ref.read(firebaseAuthProvider).currentUser;
    final advertisementList = ref.watch(feedAdvertisementsStreamProvider);

    final isSeachingOrNot = ref.watch(searchResultsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: searchAppBar(),
      body: (isSeachingOrNot)
          ? fetchSearchedAds(height)
          : advertisementList.when(
              data: (data) {
                if (data.isNotEmpty) {
                  final fileteredData = data.where((ad) => ad.userUid != currentUser!.uid).toList();
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
                  child: Text(
                    'some error occured....$error',
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
    );
  }

  Widget fetchSearchedAds(double height) {
    return ref
        .watch(fetchSearchedAdvertisementsFutureProvider(ref.read(searchQueryProvider).trim()))
        .when(data: (data) {
      if (data.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: height * 0.27,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
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
                        displayName: data[index].displayName,
                        isPosted: true,
                        model: data[index],
                      ),
                    ),
                  );
                },
                child: ItemContainer(
                  userUid: data[index].userUid,
                  itemId: data[index].itemId,
                  price: data[index].price,
                  name: data[index].name,
                  information: data[index].timestamp,
                  description: data[index].description,
                  imagePath: data[index].photoUrl[0],
                  network: true,
                ),
              );
            },
          ),
        );
      } else if (data.isEmpty) {
        return Center(
          child: Text('No Advertisements for "${ref.read(searchQueryProvider)}"'),
        );
      } else {
        return Center(
          child: Text('some unknown error'),
        );
      }
    }, error: (error, stacktrace) {
      return Center(
        child: Text('some error $error'),
      );
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    });
  }

  // search image.....
  PreferredSizeWidget searchAppBar() {
    return AppBar(
      title: Container(
        height: 50,
        child: TextField(
          onChanged: (value) {
            // changes the value of seachBarText to see
            if (value.isEmpty) {
              ref.read(searchQueryProvider.notifier).update((state) => '');
              ref.read(searchResultsProvider.notifier).update((state) => false);
              log('changed state to ' ' at line 127');
            }
          },
          keyboardType: TextInputType.text,
          cursorColor: primaryColor,
          minLines: 1,
          controller: _searchController,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ref.read(searchQueryProvider.notifier).update((state) => value.trim());
              // ref.read(searchResultsProvider.notifier).update((state) => false);
              log('changed state to ${value}');
              ref.read(searchResultsProvider.notifier).update(
                    (state) => true,
                  );
            } else {
              ref.read(searchQueryProvider.notifier).update((state) => '');
              ref.read(searchResultsProvider.notifier).update((state) => false);
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(26)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(26)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.4,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(26)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
