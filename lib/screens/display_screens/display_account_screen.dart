import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/utils/colors.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // showing user photo
          user!.photoURL != null
              ? Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                )
              : const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                ),

          const SizedBox(height: 15),

          // fetch from firestore
          FutureBuilder<UserModel>(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Text(snapshot.data!.username),
                    const SizedBox(height: 20),
                    Text(snapshot.data!.email),
                    const SizedBox(height: 20),
                    Text(snapshot.data!.userUid),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('some error ${snapshot.error}'),
                );
              } else {
                return CircularProgressIndicator(color: primaryColor);
              }
            },
            future: Authentication().fetchSingleData(user!.email!),
          )
        ],
      ),
    );
  }
}
