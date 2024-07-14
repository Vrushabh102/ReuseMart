import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/features/liked_items/repository/liked_items_repo.dart';
import 'package:seller_app/models/advertisement_model.dart';

final likedItemControllerProvider = Provider<LikedItemController>((ref) {
  return LikedItemController(ref: ref, likedItemRepository: ref.read(likedItemRepository));
});

final likedItemsFutureProvider = FutureProvider<List<AdvertisementModel>>((ref) async {
  final likedItemController = ref.read(likedItemControllerProvider);
  final likedItemIds = ref.watch(userProvider).likedAds;
  return await likedItemController.loadLikedItems(likedItemIds);
});

class LikedItemController {
  final Ref _ref;
  final LikedItemRepository _likedItemRepository;
  LikedItemController({
    required Ref ref,
    required LikedItemRepository likedItemRepository,
  })  : _likedItemRepository = likedItemRepository,
        _ref = ref;

  addLikedItem(String itemId) {
    final userstateProvider = _ref.read(userProvider.notifier);
    userstateProvider.addLikedItem(itemId);

    _scheduleUpdateLikedItemList();
  }

  removeLikedItem(String itemId) {
    final userstateProvider = _ref.read(userProvider.notifier);
    userstateProvider.removeLikedItem(itemId);

    _scheduleUpdateLikedItemList();
  }

  void _scheduleUpdateLikedItemList() {
    // Delay the execution until the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLikedItemList();
    });
  }

  Future<void> _updateLikedItemList() async {
    log('update liked item');
    final likedAdsList = _ref.read(userProvider).likedAds; // Use read instead of watch
    await _likedItemRepository.updateLikedItems(likedAdsList);
  }

  // liked item controller

 Future<List<AdvertisementModel>> loadLikedItems(List<String> listOfAds) async {
    final List<AdvertisementModel> ads = [];
    final List<QuerySnapshot> snaps = await _likedItemRepository.loadLikedItems(listOfAds);

    for (var element in snaps) {
      if (element.docs.isNotEmpty) {
        final ad = element.docs.map((e) => AdvertisementModel.fromSnapShot(e as DocumentSnapshot<Map<String, dynamic>>)).single;
        ads.add(ad);
      }
    }

    final validItemIds = ads.map((ad) => ad.itemId).toList();
    await _updateLikedItemsInUserProfile(validItemIds);

    return ads;
  }

  Future<void> _updateLikedItemsInUserProfile(List<String> validItemIds) async {
    final user = _ref.read(userProvider);
    if (user.likedAds.length != validItemIds.length) {
      final userstateProvider = _ref.read(userProvider.notifier);
      userstateProvider.updateLikedAds(validItemIds);
      await _likedItemRepository.updateLikedItems(validItemIds);
    }
  }

}
