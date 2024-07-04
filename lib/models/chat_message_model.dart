// model for reference of the chat_rooms document
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomMessageModel {
  final String sellerId;
  final String buyerId;
  final String lastMessage;
  final Timestamp timestamp;
  final String itemId;

  ChatRoomMessageModel({
    required this.sellerId,
    required this.buyerId,
    required this.itemId,
    required this.lastMessage,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'buyerId': buyerId,
      'itemId': itemId,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }

  factory ChatRoomMessageModel.fromMap(DocumentSnapshot snapshot) {
    return ChatRoomMessageModel(
      itemId: snapshot['itemId'],
      sellerId: snapshot['sellerId'],
      buyerId: snapshot['buyerId'],
      lastMessage: snapshot['lastMessage'],
      timestamp: snapshot['timestamp'],
    );
  }
}
