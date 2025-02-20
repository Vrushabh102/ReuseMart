
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/features/advertisement/repository/add_repository.dart';
import 'package:seller_app/features/home/home_screens/home_screen.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/utils/screen_sizes.dart';

// home screen advertisements stream provider
final feedAdvertisementsStreamProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final addController = ref.watch(advertisementControllerProvider);
  return addController.fetchFeedAdvertisements();
});

final advertisementControllerProvider = Provider<AdvertisementController>((ref) {
  return AdvertisementController(
    advertisementRepository: ref.watch(advertisementRepositoryProvider),
  ref: ref,
  );
});

final fetchSearchedAdvertisementsFutureProvider = FutureProvider.family<List<AdvertisementModel>, String>((ref, itemName) async {
  final advertisementRepo = ref.read(advertisementRepositoryProvider);
  final querysnaps = await advertisementRepo.searchForItems(itemName);
  final advers = querysnaps.docs.map((e) => AdvertisementModel.fromSnapShot(e as DocumentSnapshot<Map<String, dynamic>>)).toList();
  return advers;
});

class AdvertisementController {
  final AdvertisementRepository _advertisementRepository;
  // ignore: unused_field
  final Ref _ref;

  AdvertisementController({
    required AdvertisementRepository advertisementRepository,
    required Ref ref,
  })  : _advertisementRepository = advertisementRepository,
        _ref = ref;

  Stream<List<AdvertisementModel>> fetchFeedAdvertisements() {
    return _advertisementRepository.fetchFeedAdvertisements();
  }

  // to post advertisement
  postAdvertisement({
    required AdvertisementModel sellItemModel,
    required String docId,
    required BuildContext context,
  }) async {
    final result = await _advertisementRepository.postAdvertisment(
      sellItemModel: sellItemModel,
      docId: docId,
    );

    result.fold(
      (l) => showSnackBar(context: context, message: l.message),
      (r) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
        showSnackBar(context: context, message: 'Your add is live now');
      },
    );
  }

  updateAdvertisement({
    required String itemId,
    required String newPrice,
    required String newName,
    required String description,
    required List<String> photoUrls,
  }) async {
    await _advertisementRepository.updateAdvertisement(
      itemId: itemId,
      newPrice: newPrice,
      newName: newName,
      description: description,
      photoUrls: photoUrls,
    );
  }

//   // to search for any item...
//   Future<List<AdvertisementModel>> searchForItems(String itemName) async {
// //  as QuerySnapshot<Map<String, dynamic>>;
//     // final advertisements = query.docs.map((e) => AdvertisementModel.fromSnapShot(e)).toList();
//     // return advertisements;
//   }
}

final userPostedAdsProvider = StateNotifierProvider<UserPostedAdvertisements, List<AdvertisementModel>>((ref) {
  return UserPostedAdvertisements(
    ref.watch(advertisementRepositoryProvider),
  );
});

class UserPostedAdvertisements extends StateNotifier<List<AdvertisementModel>> {
  final AdvertisementRepository _advertisementRepository;
  UserPostedAdvertisements(
    this._advertisementRepository,
  ) : super([]);

  // to load all the ads posted by user
  Future<void> getAllAdsPostedByUser() async {
    final listOfAdvertisements = await _advertisementRepository.fetchAllUserAdvertisementDetails();
    state = listOfAdvertisements;
  }

  // Delete an advertisement by id and update the state
  // remove everything associated with the advertisements, like chats...
  Future<void> deleteAdvertisementById(String id) async {
    await _advertisementRepository.deleteAdvertisementById(id);
    state = state.where((ad) => ad.itemId != id).toList();

    // remove all the chats asscociated with the advertisement
    await _advertisementRepository.deleteChats(id);
  }
}
