import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_app/models/message_model.dart';

class ChatServices {
  final _fs = FirebaseFirestore.instance;

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

  
}