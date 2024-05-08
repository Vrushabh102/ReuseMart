import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/screens/login_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
