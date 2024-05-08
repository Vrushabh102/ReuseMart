import 'package:flutter/material.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/widget_styles/button_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              width: 360,
              child: Image.asset('assets/images/file.png')),
            Container(
              padding: const EdgeInsets.all(8),
              width: 360,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // for email
                  TextInputField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      obscure: false),
                  const SizedBox(height: 15),
                  // for password
                  TextInputField(
                      controller: _passController,
                      hintText: 'Password',
                      icon: Icons.lock_open_outlined,
                      obscure: true),
                  const SizedBox(height: 3),
                  const Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color.fromARGB(149, 38, 40, 190),
                          fontSize: 14),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // login button
                  ElevatedButton(
                    onPressed: () {},
                    style: loginButtonStyle(),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Center(child: Text('OR')),
                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {},
                    style: loginButtonStyle(),
                    child: const Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white),
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
}
