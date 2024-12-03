import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordNotifier extends StateNotifier<bool> {
  ForgotPasswordNotifier() : super(false);

  void updateForgotPasswordProvider(bool newVal) {
    state = newVal;
  }
}

final isForgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, bool>((ref) {
  return ForgotPasswordNotifier();
});

class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier() : super(true);

  void updateLoginFlag(bool newVal) {
    state = newVal;
  }
}

final isLoginProvider = StateNotifierProvider<LoginNotifier, bool>((ref) {
  return LoginNotifier();
});
