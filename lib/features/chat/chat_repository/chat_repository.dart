import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/firebase_providers.dart';
import 'package:seller_app/models/chat_message_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    firestore: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBuyingChats() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> documents = _firestore.collection('chat_rooms').where('buyerId', isEqualTo: _auth.currentUser!.uid).snapshots();
    return documents;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSellingChats() {
    return _firestore.collection('chat_rooms').where('sellerId', isEqualTo: _auth.currentUser!.uid).orderBy('timestamp', descending: false).snapshots();
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore.collection('chat_rooms').doc(chatId).collection('messages').doc(messageId).delete();
  }

  Future<DocumentSnapshot> fetchUserDetailsWithUid(String uid) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAdvertisementById(String id) async {
    return await _firestore.collection('items_posted').where('itemId', isEqualTo: id).get();
  }

  Future<void> initiateChat(String sellerId, String buyerId, String itemId) async {
    final chatRooms = _firestore.collection('chat_rooms');

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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessagesByChatId(String chatId) {
    return _firestore.collection('chat_rooms').doc(chatId).collection('messages').orderBy('timestamp', descending: false).snapshots().handleError((error) {
      log('some error occured at fetching messages');
    });
  }
}
