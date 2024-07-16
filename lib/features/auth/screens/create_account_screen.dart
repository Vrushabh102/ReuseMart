import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/current_screen_provider.dart';
import 'package:seller_app/core/Providers/is_loading_provider.dart';
import 'package:seller_app/core/constants.dart';
import 'package:seller_app/core/custom_widgets/text_input.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/features/auth/screens/login_screen.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends ConsumerState<SignInScreen> {
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

  List gender = ["Male", "Female"];

  String select = '';

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(
              () {
                log(value);
                select = value;
                log('selct is $select');
              },
            );
          },
        ),
        Text(title)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.4,
                  width: width * 0.9,
                  child: Image.asset(Constants.createNewAccountScreenIllustration),
                ),
                SizedBox(
                  height: height * 0.6,
                  width: width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create an account',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // for name
                      Row(
                        children: [
                          const Icon(Icons.person),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: TextInputField(inputType: TextInputType.name, autofillHints: const [AutofillHints.name], controller: _nameController, hintText: 'Full Name', obscure: false),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      // for email
                      Row(
                        children: [
                          const Icon(Icons.email),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: TextInputField(inputType: TextInputType.emailAddress, autofillHints: const [AutofillHints.email], controller: _emailController, hintText: 'Email', obscure: false),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      // for password
                      Row(
                        children: [
                          const Icon(Icons.lock),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: TextInputField(
                                inputType: TextInputType.name, autofillHints: const [AutofillHints.password], controller: _createPassController, hintText: 'Create Password', obscure: true),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          addRadioButton(0, 'Male'),
                          addRadioButton(1, 'Female'),
                        ],
                      ),

                      SizedBox(
                        height: height * 0.035,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // create new account button
                          if (_nameController.text.isEmpty || _emailController.text.isEmpty || _createPassController.text.isEmpty || select.isEmpty) {
                            showSnackBar(context: context, message: 'Enter Details');
                          } else {
                            createAccount(
                              _nameController.text,
                              _emailController.text,
                              _createPassController.text,
                              select,
                            );
                          }
                        },
                        style: loginButtonStyle().copyWith(minimumSize: MaterialStatePropertyAll(Size(width * 0.9, height * 0.06))),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      SizedBox(height: height * 0.022),
                      const Center(child: Text('OR')),
                      SizedBox(height: height * 0.022),

                      // google sing in button
                      Container(
                        decoration: googleButtonDecoration(),
                        height: height * 0.06,
                        width: width * 0.9,
                        child: ElevatedButton(
                          style: googleButtonStyle(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 22, width: 22, child: Image.asset('assets/icons/google.png')),
                              const SizedBox(width: 8),
                              const Text(
                                'Sign in with Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ), // or any other Google icon you want to use
                          onPressed: () {
                            signInWithGoogle(ref);
                          }, // Change this to your desired text color
                        ),
                      ),

                      SizedBox(height: height * 0.01),

                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                        },
                        child: const Center(
                          child: Text(
                            'Already have account? Login',
                            style: TextStyle(
                              fontSize: 13.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          (isLoading)
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // function to check user data and to redirect to homescreen
  // create account screen
  void createAccount(String name, String email, String password, String gender) async {
    await ref.read(authControllerProvider).createAccount(name, email, password, gender, context);
    ref.read(currentScrrenIndexProvider.notifier).state = 0;
    Navigator.pop(context);
  }

  // method to sign in with google and store user data to the database
  Future<void> signInWithGoogle(WidgetRef ref) async {
    await ref.watch(authControllerProvider).signInWithGoogle(context, true);
    log('navigate to home screen if no error');
  }
}
