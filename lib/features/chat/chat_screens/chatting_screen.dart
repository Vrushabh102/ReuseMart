import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seller_app/core/constants.dart';
import 'package:seller_app/core/custom_widgets/chat_bubble.dart';
import 'package:seller_app/features/advertisement/screens/view_advertisement_screen.dart';
import 'package:seller_app/features/chat/chat_controller/chat_controller.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/message_model.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/services/chat_services.dart';
import 'package:seller_app/utils/colors.dart';

class ChattingScreen extends ConsumerStatefulWidget {
  const ChattingScreen({
    super.key,
    required this.addmodel,
    required this.userModel,
    required this.isCurrentUserSelling,
  });
  final AdvertisementModel addmodel;
  final UserModel? userModel; // not null while selling
  final bool isCurrentUserSelling;
  @override
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen> {
  final textController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              // seller name container
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(width: 1),
                  ),
                ),
                padding: const EdgeInsets.only(left: 6),
                height: height * 0.08,
                width: width,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: width * 0.02),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: (widget.userModel != null)
                          ? (widget.userModel!.gender == 'Male')
                              ? const AssetImage(Constants.maleProfilePic)
                              : const AssetImage(Constants.femaleProfilePic)
                          : const AssetImage(Constants.maleProfilePic),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      widget.userModel?.fullName ?? widget.addmodel.displayName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),

              // item name, price and button arrow to goto advertisement
              InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () {
                  // goto the advertisement
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DisplayItemScreen(
                          isUpdating: false,
                          displayName: widget.addmodel.displayName,
                          isPosted: true,
                          model: widget.addmodel,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade800,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  width: width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.addmodel.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '₹${widget.addmodel.price}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // messages
              Expanded(
                child: _buildMessageList(),
              ),
              _buildMessageInput(height, width),
            ],
          ),
        ),
      ),
    );
  }

  final FocusNode focusNode = FocusNode();

  // text field for sending message
  _buildMessageInput(double height, double width) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 3),
      child: TextField(
        maxLines: null,
        minLines: 1,
        focusNode: focusNode,
        controller: textController,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            log('message sent from chatting screen');
            sendMessage(value.trim());
            textController.clear();
            focusNode.requestFocus();
          }
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                log('message sent from chatting screen');
                sendMessage(textController.text.trim());
                textController.clear();
                scrollToBottom();
                focusNode.requestFocus();
              }
            },
            icon: const Icon(Icons.send_sharp),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: 'Message',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(26)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.4,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(26)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  _buildMessageList() {
    // constructing chat id with (itemId+buyerId) for buying
    String chatId;
    if (widget.isCurrentUserSelling) {
      chatId = '${widget.addmodel.itemId}_${widget.userModel!.userUid}';
      log('fetch messgae isSelling is true $chatId');
    } else {
      chatId = '${widget.addmodel.itemId}_${auth.currentUser!.uid}';
      log('fetch message isSelling is false $chatId');
    }

    final buildMessagestraemProvider = ref.watch(buildMessagesStreamProvider(chatId));
    return buildMessagestraemProvider.when(
      data: (data) {
        if (data.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        } else {
          return ListView(
            controller: scrollController,
            children: data.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        }
      },
      error: (error, stackTrace) {
        log('An error has occurred');
        log(error.toString());
        return Center(
          child: Text('An error has occurred: $error'),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    MessageModel model = MessageModel.fromSnap(document);
    Alignment alignment;
    bool isPrimary;
    if (widget.isCurrentUserSelling) {
      // curr user is the seller, so seller should have primary colr & right alin
      alignment = (document['senderId'] == auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
      isPrimary = (document['senderId'] == auth.currentUser!.uid);
    } else {
      // curr user is the buyer, so buyer should have primary clor & right alin
      alignment = (document['senderId'] == auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
      isPrimary = (document['senderId'] == auth.currentUser!.uid);
    }
    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: model.message,
        receiver: isPrimary,
        time: convertToDateTime(model.timestamp),
      ),
    );
  }

  sendMessage(String message) {
    String chatId;
    if (widget.isCurrentUserSelling) {
      // current user is the seller: addmodel is of current user, 2nd one is buyer from userModel
      chatId = '${widget.addmodel.itemId}_${widget.userModel!.userUid}';
    } else {
      // current user is buyer so 2nd id is of currentUser & 1st is of seller i.e userModel
      chatId = '${widget.addmodel.itemId}_${auth.currentUser!.uid}';
    }

    // checking if usermodel exists to differenciate buyer and seller
    if (widget.isCurrentUserSelling) {
      // current user is the seller, userModel user is the reciver
      ChatServices().sendMessage(
        chatId: chatId,
        message: message,
        senderId: auth.currentUser!.uid,
        reciverId: widget.userModel!.userUid,
      );
    } else {
      // current user is the buyer,
      // so sender will be the userModel user & current user is the reciver
      ChatServices().sendMessage(
        chatId: chatId,
        message: message,
        senderId: auth.currentUser!.uid,
        reciverId: widget.addmodel.userUid,
      );
    }

    // scrollToBottom();
  }

  String convertToDateTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  void jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  // Scroll to bottom
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      }
    });
  }
}
