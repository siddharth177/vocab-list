import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/snackbar_messaging.dart';
import '../loading.dart';

class ForgotPasswordWidget extends ConsumerStatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  ConsumerState<ForgotPasswordWidget> createState() {
    return _ForgotPasswordWidgetState();
  }
}

class _ForgotPasswordWidgetState extends ConsumerState<ForgotPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordNotifier = ref.watch(isForgotPasswordProvider.notifier);
    Future resetPassword() async {
      final bool isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => const Center(
          child: LoadingWidget(),
        ),
      );

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        Navigator.of(context).popUntil((route) => route.isFirst);
        forgotPasswordNotifier.updateForgotPasswordProvider(false);
        clearAndDisplaySnackbar(context, 'Email for password reset sent');
      } on FirebaseAuthException catch (error) {
        clearAndDisplaySnackbar(context,
            error.message ?? 'Password reset Failed! Please try again.');
        Navigator.of(context).pop();
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Enter the registered email address. You will receive an email containing link to reset password.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) => email != null && !email.contains('@')
                ? 'Enter a valid email'
                : null,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: resetPassword,
            child: const Text('Reset Password'),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                forgotPasswordNotifier.updateForgotPasswordProvider(false);
              });
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
