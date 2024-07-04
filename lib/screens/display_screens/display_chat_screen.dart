import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/chat_tile.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/chat_message_model.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/screens/chatting_screen.dart';
import 'package:seller_app/services/chat_services.dart';

import 'package:seller_app/services/firestore_services.dart';
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

class BuyingChats extends StatefulWidget {
  const BuyingChats({super.key});

  @override
  State<BuyingChats> createState() => _BuyingChatsState();
}

class _BuyingChatsState extends State<BuyingChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: ChatServices().fetchBuyingChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('some error ${snapshot.error}');
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Text('No Chats,Explore Products and Start Buying');
            } else {
              final tileModels = snapshot.data!.docs
                  .map((e) => ChatRoomMessageModel.fromMap(e))
                  .toList();
              return FutureBuilder(
                future: fetchTiles(tileModels),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Start buying now!'));
                  }

                  final advertisementModels = snapshot.data;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(advertisementModels![index].name),
                        subtitle: Text(advertisementModels[index].displayName),
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
        ),
      ),
    );
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

  Future<List<AdvertisementModel>> fetchTiles(
      List<ChatRoomMessageModel> models) async {
    List<AdvertisementModel> addModels = [];
    for (var element in models) {
      AdvertisementModel advertisementModel =
          await FirestoreServices().getAdvertisementById(element.itemId);
      addModels.add(advertisementModel);
    }
    return addModels;
  }
}

class SellingChats extends StatefulWidget {
  const SellingChats({super.key});

  @override
  State<SellingChats> createState() => _SellingChatsState();
}

class _SellingChatsState extends State<SellingChats> {
  final contoller = TextEditingController();
  final List<UserModel> buyerNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: ChatServices().fetchSellingChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              contoller.text = snapshot.error.toString();
              return Text(
                'some error in stream builder${snapshot.error.toString()}',
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Buyers messages will appear here',
                ),
              );
            } else {
              final List<ChatRoomMessageModel> chatRoomMessageModelList =
                  snapshot.data!.docs
                      .map((e) => ChatRoomMessageModel.fromMap(e))
                      .toList();
              return FutureBuilder(
                future: fetchTiles(chatRoomMessageModelList),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'some error in future buider${snapshot.error}',
                    );
                  } else {
                    final List<AdvertisementModel> advertisementModels =
                        snapshot.data as List<AdvertisementModel>;
                    return ListView.builder(
                      itemCount: advertisementModels.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(advertisementModels[index].name),
                          subtitle:
                              Text(buyerNames[index].fullName ?? 'some user'),
                          leading: chatLeadingImage(
                            context,
                            advertisementModels[index].photoUrl[0],
                          ),
                          onTap: () {
                            log('Yooooooooooooooooo');
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
            }
          },
        ),
      ),
    );
  }

  Future<List<AdvertisementModel>> fetchTiles(
      List<ChatRoomMessageModel> models) async {
    List<AdvertisementModel> addModels = [];
    for (var element in models) {
      log(element.itemId);
      AdvertisementModel advertisementModel =
          await FirestoreServices().getAdvertisementById(element.itemId);
      addModels.add(advertisementModel);

      // to get the username of the buyer to display in chats
      final userdocument =
          await FirestoreServices().fetchUserDetailsWithUid(element.buyerId);
      buyerNames.add(userdocument);
    }
    log(buyerNames.length.toString());
    return addModels;
  }
}
