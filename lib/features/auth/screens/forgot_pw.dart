import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/custom_widgets/text_input.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/core/custom_styles/button_styles.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
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
                  autofillHints: const [AutofillHints.email],
                  controller: _controller,
                  hintText: 'Enter email associated with your account',
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
    ref.read(authControllerProvider).forgotPass(_controller.text.trim(), context);
  }
}
