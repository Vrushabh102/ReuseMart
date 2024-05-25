import 'package:flutter/material.dart';
import 'package:seller_app/utils/colors.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.receiver});
  final String message;
  final bool receiver;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: receiver ? Colors.grey : primaryColor),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
