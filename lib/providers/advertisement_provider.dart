//for advertisement state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/models/advertisement_model.dart';

final advertisementProvider = StateNotifierProvider<AdvertisementNotifier, AdvertisementModel>(
  (ref) => AdvertisementNotifier(),
);

final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

final searchResultsProvider = StateProvider<bool>((ref) {
  final query = ref.read(searchQueryProvider);
  if (query.isNotEmpty) {
    return true;
  } else {
    return false;
  }
});