import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/screens/auth/create_account.dart';
import 'package:seller_app/screens/auth/forgot_pw.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/utils/generate_username.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // 0.04 * height == 35 height in size

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // to check current theme and change colors
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
        backgroundColor: isLightTheme ? Colors.white : scaffoldDarkBackground,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
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
                    const Text('Login',
                        style: TextStyle(
                          fontSize: 22,
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
                                  controller: _emailController,
                                  hintText: 'Email',
                                  obscure: false,
                                  autofillHints: const [AutofillHints.email],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.015),

                          //pass TextField
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              SizedBox(width: width * 0.03),
                              Expanded(
                                child: TextInputField(
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
                          style: TextStyle(
                              fontSize: 13.7,
                              color: isLightTheme
                                  ? lightClickableTextColor
                                  : darkClickableTextColor),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
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
                        checkLogin();
                      },
                      style: loginButtonStyle().copyWith(
                          minimumSize: MaterialStatePropertyAll(
                              Size(width * 0.9, height * 0.06))),
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
                      child: SignInButton(
                        onPressed: () {
                          // google sign in
                          signInWithGoogle();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        Buttons.Google,
                        elevation: 0,
                        text: 'Sign in with Google',
                      ),
                    ),

                    SizedBox(height: height * 0.01),
                    // create new account text
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: Text(
                        'Create new account',
                        style: TextStyle(
                            fontSize: 13.7,
                            color: isLightTheme
                                ? lightClickableTextColor
                                : darkClickableTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // function to check user data and to redirect to homescreen
  void checkLogin() async {
    log('check login started');
    Authentication fireAuth = Authentication();
    User? user =
        await fireAuth.loginUser(_emailController.text, _passController.text);
    // redirecting to homescreen if user is valid
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (route) => false);
    } else {
      showSnackBar(context: context, message: 'user is null at login page');
    }
  }

  // method to sign in with google and store user data to the database
  void signInWithGoogle() async {
    Authentication authentication = Authentication();
    User? user = await authentication.SigninWithGoogle();
    if (user != null) {
      // store data to the firebase

      // creating user model
      UserModel userModel = UserModel(
          email: user.email.toString(),
          username: GenerateRandomUserName().generateRandomUserName(),
          userUid: user.uid,
          photoUrl: user.photoURL);

      //saving data to the database using firebase methods
      Authentication().saveUserData(userModel);

      // navigating to homepage after saving user data to the databse
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      // show snackbar
    }
  }
}
