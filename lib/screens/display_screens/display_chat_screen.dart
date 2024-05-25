import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/screens/chatting_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUserList(),
    );
  }

  buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Some error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        // show list
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => buildEachItem(doc)).toList(),
        );
      },
    );
  }

  Widget buildEachItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // display all users to the screen
    if (data['email'].toString() != FirebaseAuth.instance.currentUser!.email) {
      return ListTile(
        title: Text(data['email'].toString()),
        leading: const Icon(Icons.person),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChattingScreen(
                        receiverUserId: data['userUid'].toString(), 
                        receiverUsername: data['username'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
