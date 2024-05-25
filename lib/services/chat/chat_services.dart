import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_app/models/message_model.dart';

class ChatService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final currentUserId = auth.currentUser!.uid;
    final currentUserEmail = auth.currentUser!.email.toString();

    //creating message object using message model
    MessageModel newMessage = MessageModel(
        senderEmail: currentUserEmail,
        senderId: currentUserId,
        receiverId: receiverId,
        message: message,
        timestamp: Timestamp.now());

    // construct the uid for chatroom for both the user
    List<String> uids = [currentUserId, receiverId];
    uids.sort(); // sorting to create common uid for both the user

    String chatRoomUid = uids.join(
        '_'); // chatRoomUid is the mix of uids of sender(currentUser) and receiver

    try {
      // Add new message to Firebase Firestore
      await firestore
          .collection('chat_rooms')
          .doc(chatRoomUid)
          .collection('messages')
          .add(newMessage.toJson());
      log('Message sent successfully');
    } catch (e) {
      log('Failed to send message: $e');
      throw Exception('Failed to send message: $e');
    }

  }

  // get messages
  Stream<QuerySnapshot> getMessages(String currentUserId, String receiverId) {
    log('get messages called');
    // construcing chat room for getting messages
    List<String> uids = [currentUserId, receiverId];
    uids.sort();
    String chatRoomUid = uids.join('_');

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomUid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .handleError((error) {
      log('Error fetching messages: $error');
    });
  }
}
