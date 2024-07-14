import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/current_screen_provider.dart';
import 'package:seller_app/features/chat/chat_screens/display_chat_screen.dart';
import 'package:seller_app/screens/display_screens/display_account_screen.dart';
import 'package:seller_app/screens/display_screens/display_home_screen.dart';
import 'package:seller_app/features/advertisement/screens/display_my_ads_screen.dart';
import 'package:seller_app/features/advertisement/screens/display_sell_screen.dart';
import 'package:seller_app/utils/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // bottom nav screens list
  final List<Widget> _screens = [
    const DisplayHomeScreen(),
    const DisplayChatScreen(),
    const MyAdsScreen(),
    const AccountScreen(),
  ];

  void _onFabPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Do you want to sell your used item?',
            style: TextStyle(fontSize: 17, color: Colors.grey.shade200, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellScreen(),
                    ),
                  );
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.grey.shade200),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.grey.shade200),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReuseMart'),
      ),

      // setting the screen on this page
      body: _screens[ref.watch(currentScrrenIndexProvider)],

      bottomNavigationBar: BottomAppBar(
        height: 73.5,
        elevation: 0,
        notchMargin: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const Divider(),
            CustomBottomNavItem(
              onTap: () {
                ref.read(currentScrrenIndexProvider.notifier).state = 0;
              },
              itemIndex: 0,
              title: 'Home',
              imageProvider: const AssetImage('assets/icons/home.png'),
            ),
            const SizedBox(
              width: 7.5,
            ),
            CustomBottomNavItem(
              onTap: () {
                ref.read(currentScrrenIndexProvider.notifier).state = 1;
              },
              itemIndex: 1,
              imageProvider: const AssetImage('assets/icons/chat.png'),
              title: 'Chats',
            ),
            // sell text
            Container(
              margin: const EdgeInsets.fromLTRB(12.5, 0, 0, 5.5),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.19,
              child: Text(
                'Sell',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            CustomBottomNavItem(
              onTap: () {
                ref.read(currentScrrenIndexProvider.notifier).state = 2;
              },
              itemIndex: 2,
              title: 'My ads',
              imageProvider: const AssetImage('assets/icons/my_add.png'),
            ),
            CustomBottomNavItem(
              onTap: () {
                ref.read(currentScrrenIndexProvider.notifier).state = 3;
              },
              title: 'Account',
              itemIndex: 3,
              imageProvider: const AssetImage('assets/icons/account.png'),
            ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(100),
          child: FloatingActionButton(
            backgroundColor: lightprimaryColor,
            onPressed: _onFabPressed,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Icon(
                Icons.add,
                size: 28,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomBottomNavItem extends ConsumerWidget {
  const CustomBottomNavItem({
    super.key,
    required this.title,
    required this.imageProvider,
    required this.onTap,
    required this.itemIndex,
  });

  final String title;
  final ImageProvider imageProvider;
  final VoidCallback onTap;
  final int itemIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      radius: 30,
      borderRadius: BorderRadius.circular(100),
      splashColor: primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              imageProvider,
              color: (itemIndex == ref.read(currentScrrenIndexProvider) ? primaryColor : Colors.grey),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: (itemIndex == ref.read(currentScrrenIndexProvider)) ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
