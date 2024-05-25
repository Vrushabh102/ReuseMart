import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/chat_bubble.dart';
import 'package:seller_app/services/chat/chat_services.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen(
      {super.key,
      required this.receiverUserId,
      required this.receiverUsername});

  final String receiverUserId;
  final String receiverUsername;

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final _messageController = TextEditingController();
  ChatService service = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      service.sendMessage(
          widget.receiverUserId, _messageController.text.trim());
      // clear controller after sending
      _messageController.clear();
    }
  }

  // build message List
  Widget _buildMessageList() {
    log('build message list container called');
    return StreamBuilder(
      stream: service.getMessages(auth.currentUser!.uid, widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('An error has occurred');
          log(snapshot.error.toString());
          return Center(
            child: Text('An error has occurred: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    log('build message item container called');
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId']) == auth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var receriverColor =
        (data['senderId']) == auth.currentUser!.uid ? false : true;
    log('running correctly');
    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: data['message'], receiver: receriverColor,
      ),
    );
  }

  // bulild message input box
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
                hintText: 'Enter Message',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
      ],
    );
  }
}
