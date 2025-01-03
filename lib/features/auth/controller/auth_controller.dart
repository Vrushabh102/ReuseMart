import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/providers/current_screen_provider.dart';
import 'package:seller_app/providers/is_loading_provider.dart';
import 'package:seller_app/providers/user_provider.dart';
import 'package:seller_app/features/auth/repository/auth_repository.dart';
import 'package:seller_app/features/auth/screens/login_screen.dart';
import 'package:seller_app/features/chat/chat_controller/chat_controller.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/utils/screen_sizes.dart';

import '../../home/home_screens/home_screen.dart';

// provider for auth controller
final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeStreamProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.authStateChange;
});

class AuthController {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref;

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  // this is authController.....
  signInWithGoogle(BuildContext context, bool isOnCreateAccountScreen) async {
    // to show loading
    _ref.read(isLoadingProvider.notifier).state = true;
    final user = await _authRepository.signInWithGoogle();
    user.fold((error) {
      _ref.read(isLoadingProvider.notifier).state = false;
      return showSnackBar(context: context, message: error.message);
    }, (userModel) {
      // add recived userModel data to the userProvider
      _ref.read(userProvider.notifier).setUserDetails(userModel!);
      // store the data user data in provider.......
      _ref.read(isLoadingProvider.notifier).state = false;
      _ref.read(currentScrrenIndexProvider.notifier).state = 0;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
      if (isOnCreateAccountScreen) {
        Navigator.pop(context);
      }
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  saveUserDataToFirebase(String userUid, UserModel model) async {
    await _authRepository.saveUserDataToFirebase(userUid, model);
  }

  // auth controller
  createAccount(
    String name,
    String email,
    String password,
    String gender,
    BuildContext context,
  ) async {
    _ref.read(isLoadingProvider.notifier).state = true;
    final user = await _authRepository.createUserAuth(name, email, gender, password);
    _ref.read(isLoadingProvider.notifier).state = false;

    // handling error
    user.fold((error) {
      return showSnackBar(context: context, message: error.message);
    }, (userModel) {
      // add user data to the userProvider.....
      _ref.read(userProvider.notifier).setUserDetails(userModel);
    });
  }

  loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    _ref.read(isLoadingProvider.notifier).state = true;
    final user = await _authRepository.loginUser(email, password);
    _ref.read(isLoadingProvider.notifier).state = false;
    user.fold((l) {
      showSnackBar(context: context, message: l.message);
    }, (userModel) {
      _ref.read(userProvider.notifier).setUserDetails(userModel);
      _ref.read(chatControllerProvider).fetchBuyingChats();
      _ref.read(chatControllerProvider).fetchSellingChats();

      _ref.read(currentScrrenIndexProvider.notifier).state = 0;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false,
      );
    });
  }

  forgotPass(String email, BuildContext context) async {
    final result = await _authRepository.forgotPass(email);
    result.fold((l) {
      showSnackBar(context: context, message: l.message);
    }, (r) {
      showSnackBar(context: context, message: 'If email is valid, mail sended');
    });
  }

  logoutUser(BuildContext context) async {
    _ref.watch(isLoadingProvider.notifier).state = true;

    final result = await _authRepository.logOutUser();
    _ref.watch(isLoadingProvider.notifier).state = false;

    result.fold((l) {
      showSnackBar(context: context, message: l.message);
    }, (r) {
      _ref.invalidate(fetchBuyingChatsStreamProvider);
      _ref.invalidate(fetchSellingChatsStreamProvider);
      _ref.invalidate(chatControllerProvider);
      _ref.invalidate(userProvider);
      showSnackBar(context: context, message: 'Logged out');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    });
  }
}
