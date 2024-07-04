import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/models/chat_message_model.dart';
import 'package:seller_app/models/message_model.dart';

class ChatServices {
  final _fs = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> initiateChat(String sellerId, String buyerId, String itemId,
      BuildContext context) async {
    final chatRooms = _fs.collection('chat_rooms');

    //constructing chat ID
    final chatId = '${itemId}_$buyerId';

    // create message model for chat_rooms
    ChatRoomMessageModel messageModel = ChatRoomMessageModel(
      sellerId: sellerId,
      buyerId: buyerId,
      lastMessage: '',
      itemId: itemId,
      timestamp: Timestamp.now(),
    );

    DocumentSnapshot documentSnapshot = await chatRooms.doc(chatId).get();
    if (!documentSnapshot.exists) {
      chatRooms.doc(chatId).set(messageModel.toJson());
    }
    // chatRooms.doc(chatId).
  }

  Future<void> sendMessage(
      {required String chatId,
      required String message,
      required String senderId,
      required String reciverId}) async {
    log('chat id in send message $chatId');
    DocumentReference documentReference =
        _fs.collection('chat_rooms').doc(chatId);

    // if current user is buyer
    final messageModel = MessageModel(
      senderId: senderId,
      reciverId: reciverId,
      message: message,
      timestamp: Timestamp.now(),
    );

    CollectionReference messagesCollectionReference =
        documentReference.collection('messages');

    // adding messagemodel to the document
    messagesCollectionReference.add(messageModel.toJson());

    // updating the chat_rooms docs with the current time and last message
    await _fs.collection('chat_rooms').doc(chatId).update({
      'lastMessage': message,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBuyingChats() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> documents = _fs
        .collection('chat_rooms')
        .where('buyerId', isEqualTo: _currentUser!.uid)
        .snapshots();
    return documents;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessagesByChatId(
      String chatId) {
    return _fs
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .handleError((error) {
      log('some error occured at fetching messages');
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSellingChats() {
    return _fs
        .collection('chat_rooms')
        .where('sellerId', isEqualTo: _currentUser!.uid)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}