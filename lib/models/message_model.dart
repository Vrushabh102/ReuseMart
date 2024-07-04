import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String senderId;
  final String reciverId;
  final Timestamp timestamp; // Use Timestamp for Firestore compatibility

  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'message': message,
      'timestamp': timestamp, // Store timestamp as Timestamp
    };
  }

  factory MessageModel.fromSnap(DocumentSnapshot snapshot) {
    return MessageModel(
      senderId: snapshot['senderId'],
      reciverId: snapshot['reciverId'],
      message: snapshot['message'],
      timestamp: snapshot['timestamp'], // Assuming it's already a Timestamp
    );
  }
}
