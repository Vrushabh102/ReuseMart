import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/authentication/firebase_methods.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/custom_styles/button_styles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createPassController = TextEditingController();

  @override
  void dispose() {
    _createPassController;
    _nameController;
    _emailController;
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
                    'Create Account',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // for email
                  TextInputField(
                      autofillHints: const [AutofillHints.name],
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.lock_open_outlined,
                      obscure: false),
                  const SizedBox(height: 10),
                  // for Name
                  TextInputField(
                      autofillHints: const [AutofillHints.email],
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      obscure: false),
                  const SizedBox(
                    height: 10,
                  ),
                  // for confirming password
                  TextInputField(
                      autofillHints: const [AutofillHints.password],
                      controller: _createPassController,
                      hintText: 'Create password',
                      obscure: true,
                      icon: Icons.lock_outline),
                  const SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // create new account button
                      checkAccount();
                    },
                    style: loginButtonStyle(),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Center(child: Text('OR')),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: null,
                    // google sign in button
                    style: loginButtonStyle(),
                    child: const Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // function to check user data and to redirect to homescreen
  void checkAccount() async {
    log('check account started');
    Authentication auth = Authentication();
    User? user = await auth.createUserAuth(_nameController.text,
        _emailController.text, _createPassController.text);
    if (user == null) {
      // showing snackbar if user is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some Error Occured')),
      );
    } else {
      // store user data to the server
      Authentication firestore = Authentication();

      // converting data to user model
      final usermodel = UserModel(
          email: _emailController.text,
          username: _nameController.text,
          userUid: user.uid);

      // function to save user data to firestore
      firestore.saveUserData(usermodel);

      // redirecting to homescreen if user is valid
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (route) => false);
    }
  }
}
