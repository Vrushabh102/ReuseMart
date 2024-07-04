import 'package:flutter/material.dart';

class UserDetailsCard extends StatelessWidget {
  const UserDetailsCard({
    super.key,
    this.profilePhotoUrl,
    required this.userName,
  });
  final String? profilePhotoUrl;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListTile(
      isThreeLine: false,
      leading: const ImageIcon(AssetImage('assets/images/user_male.png')),
      title: Text(userName ?? 'No Username'),
    ));
  }
}
