import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/firebase.dart';
import '../../utils/snackbar_messaging.dart';

class LoginSignUpWidget extends ConsumerStatefulWidget {
  const LoginSignUpWidget({super.key});

  @override
  ConsumerState<LoginSignUpWidget> createState() {
    return _LoginSignUpWidgetState();
  }
}

class _LoginSignUpWidgetState extends ConsumerState<LoginSignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        final userCredentials =
            await firebaseAuthInstance.signInWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials =
            await firebaseAuthInstance.createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
      }
    } on FirebaseAuthException catch (error) {
      clearAndDisplaySnackbar(
          context, error.message ?? 'Authentication Failed. Please Try Again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoginNotifier = ref.watch(isLoginProvider.notifier);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email Address'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null ||
                  value.trim().length <= 4 ||
                  !value.contains('@')) {
                return 'Email Address is invalid';
              }

              return null;
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().length <= 6) {
                return 'Password must be atleast 6 character long.';
              }

              if (value.trim().length > 8) {
                return 'Password must be less than 9 characters.';
              }

              return null;
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          _isLogin
              ? ElevatedButton(
                  onPressed: () {
                    ref
                        .read(isForgotPasswordProvider.notifier)
                        .updateForgotPasswordProvider(true);
                  },
                  child: const Text('Forgot Password?'),
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(_isLogin ? 'Login' : 'Signup'),
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
                isLoginNotifier.updateLoginFlag(_isLogin);
              });
            },
            child: Text(
                _isLogin ? 'Create an account' : 'I already have an account'),
          ),
        ],
      ),
    );
  }
}
