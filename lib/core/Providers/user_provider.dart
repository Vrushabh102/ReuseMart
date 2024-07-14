import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/models/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier,UserModel>((ref) {
  return UserNotifier(ref);
});
