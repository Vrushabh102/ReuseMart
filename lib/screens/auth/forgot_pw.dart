import 'package:flutter/material.dart';
import 'package:seller_app/authentication/firebase_methods.dart';
import 'package:seller_app/custom_widgets/text_input.dart';
import 'package:seller_app/custom_styles/button_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextInputField(
                  autofillHints: const [AutofillHints.email],
                  controller: _controller,
                  hintText: 'Enter email associated with your account',
                  icon: Icons.email_outlined,
                  obscure: false),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => passwordReset(),
                style: loginButtonStyle(),
                child: const Text('Send mail'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passwordReset() async {
    bool isValid = await Authentication().forgotPass(_controller.text.trim());

    // isValid -> true : email sended successfully
    //            false : some error occured
    isValid
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check email to reset password')))
        : ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('email not valid')));
  }
}
