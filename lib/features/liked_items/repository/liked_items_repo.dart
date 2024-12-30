import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/providers/firebase_providers.dart';
import 'package:seller_app/providers/user_provider.dart';

final likedItemRepository = Provider<LikedItemRepository>((ref) {
  return LikedItemRepository(firebaseFirestore: ref.read(firebaseFirestoreProvider), ref: ref);
});

class LikedItemRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  LikedItemRepository({required FirebaseFirestore firebaseFirestore, required Ref ref})
      : _firebaseFirestore = firebaseFirestore,
        _ref = ref;

  Future<void> updateLikedItems(List<String> likedItems) async {
    await _firebaseFirestore.collection('users').doc(_ref.read(userProvider).userUid).update({
      'likedAds': likedItems,
    });
  }

  // this is my loadLikedItems repository fun
  // fun to load all the liked items in the liked items screen
  loadLikedItems(List<String> listOfAds) async {
    final List<QuerySnapshot> queries = [];
    for (var itemId in listOfAds) {
      final query = await _firebaseFirestore.collection('items_posted').where('itemId', isEqualTo: itemId).get();
      queries.add(query);
    }
    return queries;
  }
}
