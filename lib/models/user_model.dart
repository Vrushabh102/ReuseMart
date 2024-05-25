import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? photoUrl; //can be null if user signs in with email and password
  final String email;
  final String username; 
  final String? fullName;// can be null if user signs in with googleSignIn
  final String userUid;
  UserModel(
      {this.photoUrl,
      this.fullName,
      required this.email,
      required this.username,
      required this.userUid});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'userUid': userUid,
      'photoUrl': photoUrl
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
        photoUrl: data['photoUrl'],
        email: data['email'],
        username: data['username'],
        userUid: data['userUid']);
  }
}
