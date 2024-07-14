
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_app/models/advertisement_model.dart';

class FirestoreServices {
  // firebase database instance
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // FIRESTORE METHODS
  // firestore function to store user data to the database

  Future<AdvertisementModel> getAdvertisementById(String id) async {
    final querySnaps = await _fs
        .collection('items_posted')
        .where('itemId', isEqualTo: id)
        .get();
    final advertisementModel =
        querySnaps.docs.map((e) => AdvertisementModel.fromSnapShot(e)).single;
    return advertisementModel;
  }

}
