import 'package:flutter/material.dart';
import 'package:seller_app/utils/colors.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.receiver,
    required this.time,
  });
  final String message;
  final bool receiver;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: receiver ? primaryColor : Colors.grey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
