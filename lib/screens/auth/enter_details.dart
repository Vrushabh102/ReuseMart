import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/custom_styles/button_styles.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:seller_app/services/authentication/firebase_methods.dart';
import 'package:seller_app/utils/colors.dart';
import 'package:seller_app/utils/generate_username.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class FillDetailsScreen extends StatefulWidget {
  const FillDetailsScreen({super.key,required this.gender, this.name});

  final String gender;
  final String? name;

  @override
  State<FillDetailsScreen> createState() => _FillDetailsScreenState();
}

class _FillDetailsScreenState extends State<FillDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List gender = ["Male", "Female", "Other"];

  String select = 'Male';

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              log(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // to check current theme and change colors
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    // check if displayname is passed or not
    if (widget.name != null && widget.name!.isNotEmpty) {
      // name is passed from login page
      _nameController.text = widget.name as String;
    }

    return Scaffold(
      backgroundColor: isLightTheme ? Colors.white : scaffoldDarkBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter basic info',
                      style: TextStyle(
                        fontSize: 22,
                      )),
                  SizedBox(height: height * 0.05),
                  Row(
                    children: [
                      const Icon(Icons.person),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: TextInputField(
                          controller: _nameController,
                          hintText: 'Full name',
                          obscure: false,
                          autofillHints: const [AutofillHints.name],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    children: <Widget>[
                      addRadioButton(0, 'Male'),
                      addRadioButton(1, 'Female'),
                      addRadioButton(2, 'Others'),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      saveUserDataAndNavigateToHomeScreen();
                    } else {
                      showSnackBar(context: context, message: 'Enter Details');
                    }
                  },
                  style: loginButtonStyle().copyWith(
                      minimumSize: MaterialStatePropertyAll(
                          Size(width * 0.9, height * 0.065))),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUserDataAndNavigateToHomeScreen() async {
    //STORING DATA TO THE FIREBASE
    final user = FirebaseAuth.instance.currentUser;

    // creating user model
    UserModel userModel = UserModel(
      gender: widget.gender,
      fullName: widget.name,
      email: user!.email.toString(),
      username: GenerateRandomUserName().generateRandomUserName(),
      userUid: user.uid,
    );

    //saving data to the database using firebase methods
    await APIs().saveUserData(userModel);

    //Navigate to the homescreen
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false);
  }
}
