import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class AdvertisementModel {
  final String name;
  final String userEmail;
  final String description;
  final List<String> photoUrl;
  final String price;
  final String timestamp;

  const AdvertisementModel({
    required this.timestamp,
    required this.userEmail,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'userEmail': userEmail,
      'description': description,
      'photoUrl': photoUrl,
      'price': price,
      'name': name
    };
  }

  factory AdvertisementModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return AdvertisementModel(
      timestamp: data['timestamp'],
      userEmail: data['userEmail'],
      name: data['name'],
      description: data['description'],
      photoUrl: List<String>.from(data['photoUrl']),
      price: data['price'],
    );
  }

  AdvertisementModel copyWith({
    String? name,
    String? userEmail,
    String? description,
    List<String>? photoUrl,
    String? price,
    String? timestamp,
  }) {
    return AdvertisementModel(
      name: name ?? this.name,
      userEmail: userEmail ?? this.userEmail,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}