import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/custom_widgets/chat_tile.dart';
import 'package:seller_app/features/chat/chat_controller/chat_controller.dart';
import 'package:seller_app/features/chat/chat_screens/chatting_screen.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/chat_message_model.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/utils/colors.dart';

class DisplayChatScreen extends StatefulWidget {
  const DisplayChatScreen({super.key});

  @override
  State<DisplayChatScreen> createState() => _DisplayChatScreennState();
}

class _DisplayChatScreennState extends State<DisplayChatScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          tabs: const [
            SizedBox(
              height: 50,
              child: Center(
                child: Text('Buying'),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text('Selling'),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            BuyingChats(),
            SellingChats(),
          ],
        ),
      ),
    );
  }
}

class BuyingChats extends ConsumerStatefulWidget {
  const BuyingChats({super.key});

  @override
  ConsumerState<BuyingChats> createState() => _BuyingChatsState();
}

class _BuyingChatsState extends ConsumerState<BuyingChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ref.watch(fetchBuyingChatsStreamProvider).when(
        data: (data) {
          if (data.docs.isEmpty) {
            return const Text('No Chats,Explore Products and Start Buying');
          } else {
            final tileModels = data.docs.map((e) => ChatRoomMessageModel.fromMap(e)).toList();
            return FutureBuilder(
              future: fetchTiles(tileModels),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  CircularProgressIndicator(
                    color: primaryColor,
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('Start buying now!'));
                }

                final advertisementModels = snapshot.data;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      title: Text(advertisementModels![index].name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            advertisementModels[index].displayName,
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            tileModels[index].lastMessage,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      leading: chatLeadingImage(
                        context,
                        advertisementModels[index].photoUrl[0],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // make sure who is the seller and who is the buyer,
                              // bcs reciver will always indicated to the other phone
                              return ChattingScreen(
                                addmodel: advertisementModels[index],
                                userModel: null,
                                isCurrentUserSelling: false,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
        error: (e, s) {
          return Text('some error $e');
        },
        loading: () {
          return CircularProgressIndicator(
            color: primaryColor,
          );
        },
      )),
    );
  }

  Future<List<AdvertisementModel>> fetchTiles(List<ChatRoomMessageModel> models) async {
    List<AdvertisementModel> addModels = [];
    for (var element in models) {
      final advertisementModel = await ref.watch(chatControllerProvider).getAdvertisementById(element.itemId);

      addModels.add(advertisementModel);
    }
    return addModels;
  }

  removeReciveruserChats(String reciverUid, String reciverUsername) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to delete chats?'),
          actions: [
            TextButton(
              onPressed: () {
                // remove the user chats
                // ChatServices().deleteReciverFromBuyChats(
                //   currentUserUid: _currentUser.currentUser!.uid,
                //   reciverUid: reciverUid,
                //   reciverUsername: reciverUsername,
                // );
                Navigator.of(context).pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // do noting
                Navigator.of(context).pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }
}

class SellingChats extends ConsumerStatefulWidget {
  const SellingChats({super.key});

  @override
  ConsumerState<SellingChats> createState() => _SellingChatsState();
}

class _SellingChatsState extends ConsumerState<SellingChats> {
  final contoller = TextEditingController();
  final List<UserModel> buyerNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ref.watch(fetchSellingChatsStreamProvider).when(
          data: (data) {
            final List<ChatRoomMessageModel> chatRoomMessageModelList = data.docs.map((e) => ChatRoomMessageModel.fromMap(e)).toList();
            return FutureBuilder(
              future: fetchTiles(chatRoomMessageModelList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                if (snapshot.data?.length == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No chats, Start Selling now!'),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'some error in future buider${snapshot.error}',
                  );
                } else {
                  final List<AdvertisementModel> advertisementModels = snapshot.data as List<AdvertisementModel>;
                  return ListView.builder(
                    itemCount: advertisementModels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        isThreeLine: true,
                        title: Text(advertisementModels[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              advertisementModels[index].displayName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              chatRoomMessageModelList[index].lastMessage,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        leading: chatLeadingImage(
                          context,
                          advertisementModels[index].photoUrl[0],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // make sure who is the seller and who is the buyer,
                                // bcs reciver will always indicated to the other phone
                                return ChattingScreen(
                                  addmodel: advertisementModels[index],
                                  userModel: buyerNames[index],
                                  isCurrentUserSelling: true,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
          error: (e, s) {
            return Text('some error $e');
          },
          loading: () {
            return CircularProgressIndicator(
              color: primaryColor,
            );
          },
        ),
      ),
    );
  }

  Future<List<AdvertisementModel>> fetchTiles(List<ChatRoomMessageModel> models) async {
    List<AdvertisementModel> addModels = [];
    final chatController = ref.watch(chatControllerProvider);
    for (var element in models) {
      log(element.itemId);
      AdvertisementModel advertisementModel = await chatController.getAdvertisementById(element.itemId);
      addModels.add(advertisementModel);

      // to get the username of the buyer to display in chats
      final userdocument = await chatController.fetchUserDetailsWithUid(element.buyerId);
      log(userdocument.email);
      buyerNames.add(userdocument);
    }
    log(buyerNames.length.toString());
    return addModels;
  }
}
