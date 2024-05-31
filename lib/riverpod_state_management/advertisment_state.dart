import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/models/advertisement_model.dart';

class AdvertisementNotifier extends StateNotifier<AdvertisementModel> {
  AdvertisementNotifier()
      : super(const AdvertisementModel(
            timestamp: '',
            userEmail: '',
            name: '',
            description: '',
            photoUrl: [],
            price: ''));

  void setValues(
      {required String setName,
      required String setDescription,
      required String setPrice}) {
    state = state.copyWith(
        name: setName, description: setDescription, price: setPrice);
  }
}
