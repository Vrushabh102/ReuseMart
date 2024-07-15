import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/is_loading_provider.dart';
import 'package:seller_app/core/custom_widgets/text_input.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/features/auth/screens/create_account_screen.dart';
import 'package:seller_app/features/auth/screens/forgot_pw.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    //provider for state of isLoading
    final isLoading = ref.watch(isLoadingProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // to check current theme and change colors
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? Colors.white : scaffoldDarkBackground,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                // container with image height 0.45 of all screen
                Container(
                  // padding around image container
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                  height: height * 0.45,
                  width: width,
                  child: Image.asset('assets/images/login.png'),
                ),

                // Login TextInput Container
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 0, 30, 0),
                  height: height * 0.25,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login',
                          style: TextStyle(
                            fontSize: height * 0.028,
                          )),
                      SizedBox(height: height * 0.02),

                      // textfields
                      AutofillGroup(
                        child: Column(
                          children: [
                            // Email TextField
                            Row(
                              children: [
                                const Icon(Icons.person),
                                SizedBox(width: width * 0.03),
                                Expanded(
                                  child: TextInputField(
                                    inputType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    hintText: 'Email',
                                    obscure: false,
                                    autofillHints: const [AutofillHints.email],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.01),
                            //pass TextField
                            Row(
                              children: [
                                const Icon(Icons.lock),
                                SizedBox(width: width * 0.03),
                                Expanded(
                                  child: TextInputField(
                                    inputType: TextInputType.name,
                                    onSubmit: (p0) {
                                      if (_emailController.text.isEmpty) {
                                        showSnackBar(context: context, message: 'Enter email');
                                      } else if (_passController.text.isEmpty) {
                                        showSnackBar(context: context, message: 'Enter password');
                                      } else {
                                        checkLogin();
                                      }
                                    },
                                    controller: _passController,
                                    hintText: 'Password',
                                    obscure: true,
                                    autofillHints: const [AutofillHints.password],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // forgot pass text
                      Container(
                        margin: EdgeInsets.only(top: height * 0.01),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(fontSize: height * 0.018, color: isLightTheme ? lightClickableTextColor : darkClickableTextColor),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // button container with height 0.3 of total
                SizedBox(
                  height: height * 0.3,
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.035),

                      // login button
                      ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            showSnackBar(context: context, message: 'Enter email');
                          } else if (_passController.text.isEmpty) {
                            showSnackBar(context: context, message: 'Enter password');
                          } else {
                            checkLogin();
                          }
                        },
                        style: loginButtonStyle().copyWith(
                          minimumSize: MaterialStatePropertyAll(
                            Size(width * 0.9, height * 0.06),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),

                      SizedBox(height: height * 0.022),

                      const Text(
                        'OR',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),

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
                      // create new account text
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Create new account',
                          style: TextStyle(
                            fontSize: 13.7,
                            color: isLightTheme ? lightClickableTextColor : darkClickableTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      ),
    );
  }

  // this is login screen
  // method to sign in with google and store user data to the database
  Future<void> signInWithGoogle(WidgetRef ref) async {
    await ref.watch(authControllerProvider).signInWithGoogle(context);
    log('login screen signInwithGoogle ended');
  }

  // function to check user data and to redirect to homescreen
  void checkLogin() async {
    await ref.watch(authControllerProvider).loginUser(_emailController.text, _passController.text, context);
  }
}
