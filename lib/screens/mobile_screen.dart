import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/screens/auth/login_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? HomeScreen(
            user: FirebaseAuth.instance.currentUser,
          )
        : const LoginScreen();
  }
}