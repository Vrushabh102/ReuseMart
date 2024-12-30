import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/common/custom_widgets/text_input.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/common/custom_styles/button_styles.dart';
import 'package:seller_app/utils/screen_sizes.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
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
                  inputType: TextInputType.emailAddress, autofillHints: const [AutofillHints.email], controller: _controller, hintText: 'Enter email associated with your account', obscure: false),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    showSnackBar(context: context, message: 'enter your mail');
                  } else {
                    passwordReset();
                  }
                },
                style: loginButtonStyle(),
                child: const Text(
                  'Send mail',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passwordReset() async {
    ref.read(authControllerProvider).forgotPass(_controller.text.trim(), context);
  }
}
