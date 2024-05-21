import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String userUid;
  UserModel(
      {required this.email, required this.username, required this.userUid});

  Map<String, dynamic> toJson() {
    return {'email': email, 'username': username, 'userUid': userUid};
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
        email: data['email'],
        username: data['username'],
        userUid: data['userUid']);
  }
}