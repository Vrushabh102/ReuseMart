import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_app/core/Providers/firebase_providers.dart';
import 'package:seller_app/core/failure.dart';
import 'package:seller_app/core/type_defs.dart';
import 'package:seller_app/models/advertisement_model.dart';

final advertisementRepositoryProvider = Provider((ref) {
  return AdvertisementRepository(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(
      firebaseFirestoreProvider,
    ),
  );
});

class AdvertisementRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AdvertisementRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  CollectionReference get _itemsPosted => _firestore.collection('items_posted');

  // to fetch all the ads posted by user in display myads screen
  Future<List<AdvertisementModel>> fetchAllUserAdvertisementDetails() async {
    final uid = _auth.currentUser!.uid;
    final ads = await _itemsPosted.where('userUid', isEqualTo: uid).get();
    final list = ads.docs.map((e) => AdvertisementModel.fromSnapShot(e as DocumentSnapshot<Map<String, dynamic>>)).toList();
    log('length of fetched list in repo' + list.length.toString());
    return list;
  }

  // to fetch all the ads to disply in homescreen
  Stream<List<AdvertisementModel>> fetchFeedAdvertisements() {
    return _itemsPosted.snapshots().map((event) {
      return event.docs.map((e) => AdvertisementModel.fromSnapShot(e as DocumentSnapshot<Map<String, dynamic>>)).toList();
    });
  }

  // fun to post advertisment to the database
  FutureVoid postAdvertisment({required AdvertisementModel sellItemModel, required String docId}) async {
    try {
      final result = await _itemsPosted.doc(docId).set(sellItemModel.toJson());
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // fun to delete advertisement
  Future<void> deleteAdvertisementById(String id) async {
    return await _firestore.collection('items_posted').doc(id).delete();
  }

  Future<void> deleteChats(String itemId) async {
    final querySnapshot = await _firestore.collection('chat_rooms').where('itemId', isEqualTo: itemId).get();
    final List<String> chatDocId = [];
    querySnapshot.docs.map((e) => chatDocId.add(e.id));

    if (chatDocId.isNotEmpty) {
      for (var element in chatDocId) {
        await _firestore.collection('chat_rooms').doc(element).delete();
      }
    }
    chatDocId.clear();
  }

  FutureVoid updateAdvertisement({
    required String itemId,
    required String newPrice,
    required String newName,
    required String description,
    required List<String> photoUrls,
  }) async {
    try {
      final result = await _itemsPosted.doc(itemId).update({
        'description': description,
        'name': newName,
        'price': newPrice,
        'photoUrl': photoUrls,
      });
      return right(result);
    } catch (e) {
      log('some error');
      return left(Failure(e.toString()));
    }
  }

  Future<QuerySnapshot<Object?>> searchForItems(String filteredItemInput) async {
    // search for items equal to any one of these....
    String firstCaps = filteredItemInput[0].toUpperCase() + filteredItemInput.toLowerCase().substring(1, filteredItemInput.length);
    log('i am searching for $firstCaps');
    // Firestore query for items where the name starts with the filtered input
    return await _itemsPosted.where('name', isEqualTo: firstCaps).get();
  }
}
