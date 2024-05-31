
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:seller_app/screens/auth/login_screen.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/utils/generate_username.dart';
import 'package:seller_app/utils/screen_sizes.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(
                height: height * 0.4,
                width: width * 0.9,
                child: Image.asset('assets/images/file.png')),
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
                        child: TextInputField(
                            autofillHints: const [AutofillHints.name],
                            controller: _nameController,
                            hintText: 'Full Name',
                            obscure: false),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  // for email
                  Row(
                    children: [
                      const Icon(Icons.email),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: TextInputField(
                            autofillHints: const [AutofillHints.email],
                            controller: _emailController,
                            hintText: 'Email',
                            obscure: false),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  // for confirming password
                  Row(
                    children: [
                      const Icon(Icons.lock),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: TextInputField(
                            autofillHints: const [AutofillHints.password],
                            controller: _createPassController,
                            hintText: 'Create Password',
                            obscure: true),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // create new account button
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _createPassController.text.isEmpty) {
                        showSnackBar(
                            context: context, message: 'Enter Details');
                      }
                      checkAccount();
                    },
                    style: loginButtonStyle().copyWith(
                        minimumSize: MaterialStatePropertyAll(
                            Size(width * 0.9, height * 0.06))),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  SizedBox(height: height * 0.022),
                  const Center(child: Text('OR')),
                  SizedBox(height: height * 0.022),

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

                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
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
    );
  }

  // function to check user data and to redirect to homescreen
  void checkAccount() async {
    APIs auth = APIs();
    User? user = await auth.createUserAuth(_nameController.text,
        _emailController.text, _createPassController.text);
    if (user == null) {
      // showing snackbar if user is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some Error Occured')),
      );
    } else {
      // store user data to the server
      APIs firestore = APIs();

      // converting data to user model
      final usermodel = UserModel(
          gender: 'gender from create account not set yet',
          email: _emailController.text,
          fullName: _nameController.text,
          username: GenerateRandomUserName().generateRandomUserName(),
          userUid: user.uid,
          photoUrl: null);

      // function to save user data to firestore
      // TODO
      firestore.saveUserData(usermodel);

      // redirecting to homescreen if user is valid
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (route) => false);
    }
  }

  void signInWithGoogle() async {
    APIs authentication = APIs();
    User? user = await authentication.signInWithGoogle();
    if (user != null) {
      // store data to the firebase

      // creating user model
      UserModel userModel = UserModel(
          email: user.email.toString(),
          gender: 'gender from create account not set yet',
          username: GenerateRandomUserName().generateRandomUserName(),
          userUid: user.uid,
          photoUrl: user.photoURL);

      //saving data to the database using firebase methods
      APIs().saveUserData(userModel);

      // navigating to homepage after saving user data to the databse
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      // show snackbar
    }
  }
}
