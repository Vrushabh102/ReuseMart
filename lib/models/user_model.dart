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

  const UserModel({
    this.photoUrl,
    required this.gender,
    required this.fullName,
    required this.email,
    required this.userUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullName,
      'email': email,
      'userUid': userUid,
      'gender': gender,
      'photoUrl': photoUrl
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
        fullName: data['fullname'],
        gender: data['gender'],
        photoUrl: data['photoUrl'],
        email: data['email'],
        userUid: data['userUid']);
  }

  UserModel copyWith({
    String? photoUrl,
    String? email,
    String? fullName,
    String? userUid,
    String? gender,
  }) {
    return UserModel(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userUid: userUid ?? this.userUid,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
      : super(
          const UserModel(
              gender: '', fullName: '', email: '', userUid: '', photoUrl: null),
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
}
