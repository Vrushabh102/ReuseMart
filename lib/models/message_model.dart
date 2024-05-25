import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderEmail;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  MessageModel(
      {required this.senderEmail,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  Map<String,dynamic> toJson() {
    return {
      'senderEmail' : senderEmail,
      'senderId' : senderId,
      'receiverId' : receiverId,
      'message' : message,
      'timestamp' : timestamp
    };
  }
}
