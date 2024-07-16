import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UserModel {
  final String? photoUrl; //can be null if user signs in with email and password
  final String email;
  final String? fullName;
  final String userUid;
  final String? gender;
  final List<String> likedAds;

  const UserModel({
    this.photoUrl,
    required this.gender,
    required this.fullName,
    required this.email,
    required this.userUid,
    required this.likedAds,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullName,
      'email': email,
      'userUid': userUid,
      'gender': gender,
      'photoUrl': photoUrl,
      'likedAds': likedAds,
    };
  }

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    final data = documentSnapshot.data()!;
    return UserModel(
      likedAds: List<String>.from(data['likedAds']),
      fullName: data['fullname'],
      gender: data['gender'],
      photoUrl: data['photoUrl'],
      email: data['email'],
      userUid: data['userUid'],
    );
  }

  UserModel copyWith({
    String? photoUrl,
    String? email,
    String? fullName,
    String? userUid,
    String? gender,
    List<String>? likedAds,
  }) {
    return UserModel(
      likedAds: likedAds ?? this.likedAds,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userUid: userUid ?? this.userUid,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

class UserNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  UserNotifier(this.ref)
      : super(
          const UserModel(
            gender: '',
            fullName: '',
            email: '',
            userUid: '',
            photoUrl: null,
            likedAds: [],
          ),
        );

  void setUserDetails(UserModel userModel) {
    state = userModel;
  }

  void setFullname(String newName) {
    state = state.copyWith(fullName: newName);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void addLikedItem(String itemId) {
    state = state.copyWith(likedAds: [...state.likedAds, itemId]);
  }

  void removeLikedItem(String itemId) {
    state = state.copyWith(likedAds: state.likedAds.where((element) => element != itemId).toList());
  }

  void updateLikedAds(List<String> newLikedAds) {
    state = state.copyWith(likedAds: newLikedAds);
  }
}
