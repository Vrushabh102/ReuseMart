import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/user_model.dart';

class FirestoreServices {
  // firebase database instance
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FIRESTORE METHODS
  // firestore function to store user data to the database

  Future<UserModel> fetchUserDetailsWithUid(String uid) async {
    DocumentSnapshot snapshot = await _fs.collection('users').doc(uid).get();
    final userData = UserModel.fromSnapshot(
        snapshot as DocumentSnapshot<Map<String, dynamic>>);
    return userData;
  }

  // fun to post advertisment to the database
  Future<void> postAdvertisment(
      {required AdvertisementModel sellItemModel,
      required String docId}) async {
    log('post ad firebase method');
    _fs.collection('items_posted').doc(docId).set(sellItemModel.toJson());
  }

  // to fetch all the ads posted by user in display myads screen
  Future<List<AdvertisementModel>> fetchAllUserAdvertisementDetails() async {
    final uid = _auth.currentUser!.uid;
    final ads = await _fs
        .collection('items_posted')
        .where('userUid', isEqualTo: uid)
        .get();
    final listAds =
        ads.docs.map((e) => AdvertisementModel.fromSnapShot(e)).toList();
    return listAds;
  }

  // to fetch all the ads to disply in homescreen
  Future<QuerySnapshot<Map<String, dynamic>>> fetchFeedAdvertisements() async {
    final advertisements = await _fs.collection('items_posted').get();
    return advertisements;
  }

  Future<AdvertisementModel> getAdvertisementById(String id) async {
    final querySnaps = await _fs
        .collection('items_posted')
        .where('itemId', isEqualTo: id)
        .get();
    final advertisementModel =
        querySnaps.docs.map((e) => AdvertisementModel.fromSnapShot(e)).single;
    return advertisementModel;
  }

  // fun to delete advertisement
  Future<void> deleteAdvertisementById(String id) async {
    return await _fs.collection('items_posted').doc(id).delete();
  }
}
