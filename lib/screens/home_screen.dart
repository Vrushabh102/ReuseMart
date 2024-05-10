import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/authentication/firebase_auth.dart';
import 'package:seller_app/screens/auth/login_screen.dart';
import 'package:seller_app/screens/display_screens/display_account_screen.dart';
import 'package:seller_app/screens/display_screens/display_chat_screen.dart';
import 'package:seller_app/screens/display_screens/display_home_screen.dart';
import 'package:seller_app/screens/display_screens/display_my_ads_screen.dart';
import 'package:seller_app/screens/display_screens/display_sell_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavBarIndex = 0;
  final List<Widget> _screens = [
    const DisplayHomeScreen(),
    const ChatScreen(),
    const SellScreen(),
    const MyAdsScreen(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReuseMart'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Authentication authentication = Authentication();
            authentication.logOutUser();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          },
        ),
      ),

      // setting the screen on this page
      body: _screens[bottomNavBarIndex],

      // bottom nav bar 5 screens (home,chat,sell,myads,account)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavBarIndex,
        onTap: (index) {
          setState(() {
            bottomNavBarIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF598BED),
        selectedIconTheme: const IconThemeData(color: Color(0xFF598BED)),
        unselectedItemColor: Colors.grey[600],
        unselectedLabelStyle: const TextStyle(color: Colors.green),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sell_outlined), label: 'Sell'),
          BottomNavigationBarItem(icon: Icon(Icons.ads_click), label: 'My ads'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
