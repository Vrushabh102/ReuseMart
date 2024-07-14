import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AdvertisementModel {
  final String name;
  final String description;
  final List<String> photoUrl;
  final String price;
  final String timestamp;
  final String? profilePhotoUrl;
  final String displayName;
  final String userUid;
  final String itemId;

  const AdvertisementModel({
    required this.displayName,
    required this.itemId,
    required this.userUid,
    required this.profilePhotoUrl,
    required this.timestamp,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userUid': userUid,
      'timestamp': timestamp,
      'description': description,
      'photoUrl': photoUrl,
      'price': price,
      'name': name,
      'profilePhotoUrl': profilePhotoUrl,
      'displayName': displayName
    };
  }

  factory AdvertisementModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return AdvertisementModel(
      itemId: data['itemId'],
      userUid: data['userUid'],
      timestamp: data['timestamp'],
      name: data['name'],
      description: data['description'],
      photoUrl: List<String>.from(data['photoUrl']),
      price: data['price'],
      displayName: data['displayName'],
      profilePhotoUrl: data['profilePhotoUrl'],
    );
  }

  AdvertisementModel copyWith({
    String? name,
    String? description,
    List<String>? photoUrl,
    String? price,
    User? user,
    String? userUid,
    String? timestamp,
    String? itemId,
  }) {
    return AdvertisementModel(
      itemId: itemId ?? this.itemId,
      userUid: userUid ?? this.userUid,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
      displayName: displayName,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}

class AdvertisementNotifier extends StateNotifier<AdvertisementModel> {
  AdvertisementNotifier() : super(const AdvertisementModel(timestamp: '', displayName: '', profilePhotoUrl: '', userUid: '', name: '', description: '', photoUrl: [], itemId: '', price: ''));

  void setValues({
    required String setName,
    required String setDescription,
    required String setPrice,
  }) {
    state = state.copyWith(name: setName, description: setDescription, price: setPrice);
  }

  void clearState() {
    state = state.copyWith(name: '', description: '', price: '');
  }

  void setAdvertisementId({required String itemId}) {
    state = state.copyWith(itemId: itemId);
  }

  void updateAdvertisementTextFields({
    required String name,
    required String description,
    required String price,
  }) {
    state = state.copyWith(
      name: name,
      description: description,
      price: price,
    );
  }
}
