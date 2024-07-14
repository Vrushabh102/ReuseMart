//for advertisement state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/models/advertisement_model.dart';

final advertisementProvider =
    StateNotifierProvider<AdvertisementNotifier, AdvertisementModel>(
  (ref) => AdvertisementNotifier(),
);
