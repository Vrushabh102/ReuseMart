import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/features/chat/chat_repository/chat_repository.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/user_model.dart';

final chatControllerProvider = Provider<ChatController>(
  (ref) {
    return ChatController(
      chatRepository: ref.read(chatRepositoryProvider),
      ref: ref,
    );
  },
);

final buildMessagesStreamProvider = StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>((ref, chatId) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.fetchMessagesByChatId(chatId);
});

// stream provider for fetching buying chat list
final fetchBuyingChatsStreamProvider = StreamProvider((ref) {
  return ref.watch(chatControllerProvider).fetchBuyingChats();
});

// chat controller
// stream provider for fetching chat list
final fetchSellingChatsStreamProvider = StreamProvider((ref) {
  return ref.watch(chatControllerProvider).fetchSellingChats();
});

class ChatController {
  final ChatRepository _chatRepository;

  ChatController({
    required ChatRepository chatRepository,
    required Ref ref,
  }) : _chatRepository = chatRepository;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBuyingChats() {
    return _chatRepository.fetchBuyingChats();
  }

  Future<UserModel> fetchUserDetailsWithUid(String uid) async {
    final res = await _chatRepository.fetchUserDetailsWithUid(uid);
    return UserModel.fromSnapshot(res as DocumentSnapshot<Map<String, dynamic>>);
  }

  deleteMessage(String chatId, String messageDocId) async {
    await _chatRepository.deleteMessage(chatId, messageDocId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSellingChats() {
    return _chatRepository.fetchSellingChats();
  }

  Future<AdvertisementModel> getAdvertisementById(String id) async {
    final doc = await _chatRepository.getAdvertisementById(id);
    final adDoc = doc.docs.map((e) => AdvertisementModel.fromSnapShot(e)).single;
    return adDoc;
  }

  Future<void> initiateChat(String sellerId, String buyerId, String itemId) async {
    await _chatRepository.initiateChat(sellerId, buyerId, itemId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessagesByChatId(String chatId) {
    return _chatRepository.fetchMessagesByChatId(chatId);
  }
}
