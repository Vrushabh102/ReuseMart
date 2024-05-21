import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/authentication/firebase_methods.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/screens/auth/create_account.dart';
import 'package:seller_app/screens/auth/forgot_pw.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/custom_styles/button_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: maxHeight * 0.4,
                width: maxWidth * 0.9,
                child: Image.asset('assets/images/file.png')),
            Container(
              padding: const EdgeInsets.all(2),
              height: maxHeight * 0.56,
              width: maxWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // for email
                  AutofillGroup(
                    child: Column(
                      children: [
                        TextInputField(
                            autofillHints: const [AutofillHints.email],
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email_outlined,
                            obscure: false),
                        const SizedBox(height: 10),
                        // for password
                        TextInputField(
                            autofillHints: const [AutofillHints.password],
                            controller: _passController,
                            hintText: 'Password',
                            icon: Icons.lock_open_outlined,
                            obscure: true),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                            (route) => false);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: primaryColor, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // login button
                  ElevatedButton(
                    onPressed: () async {
                      // login user
                      checkLogin();
                    },
                    style: loginButtonStyle(),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Center(child: Text('OR')),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: null,
                    // sign in with google
                    style: loginButtonStyle(),
                    child: const Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                            (route) => false);
                      },
                      child: Text(
                        'Create new account',
                        style: TextStyle(color: primaryColor, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // function to check user data and to redirect to homescreen
  void checkLogin() async {
    log('check login started');
    Authentication fireAuth = Authentication();
    User? user =
        await fireAuth.loginUser(_emailController.text, _passController.text);
    log('${user!.email}');
    if (user == null) {
      // showing snackbar if user is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some Error Occured')),
      );
    } else {
      // redirecting to homescreen if user is valid
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (route) => false);
    }
  }
}
