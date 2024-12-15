import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import '../../utils/firebase.dart';
import '../../utils/snackbar_messaging.dart';
import '../vocab_list.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() {
    return _EmailVerificationScreenState();
  }
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = firebaseAuthInstance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 1), (_) => checkEmailVerificationStatus());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = firebaseAuthInstance.currentUser!;
      await user.sendEmailVerification();

      clearAndDisplaySnackbar(context, 'Verification Mail Sent');

      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        canResentEmail = true;
      });
    } on FirebaseAuthException catch (error) {
      clearAndDisplaySnackbar(
          context, error.message ?? 'Authentication Failed');
    }
  }

  Future checkEmailVerificationStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = firebaseAuthInstance.currentUser!.emailVerified;
    });

    isEmailVerified ? timer?.cancel() : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const WordsListScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(200, 123, 123, 123)
                : Colors.transparent,
          ),
          const RiveAnimation.asset('assets/animations/rive/spin.riv'),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: const SizedBox(),
          )),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome,\nto Your Vocab List',
                      style: TextStyle(
                        fontSize: 55,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Just One more step...',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 40,
                          color: Colors.white.withOpacity(0.65),
                          margin: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                          'A verification email has been sent out to your registered email id.'),
                                    ),
                                    //cancel button
                                    ElevatedButton(
                                        onPressed: () {
                                          firebaseAuthInstance.signOut();
                                        },
                                        child: const Text('Signout')),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (canResentEmail) {
                                            sendVerificationEmail();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Verification Email has already been sent'),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Resend')),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
