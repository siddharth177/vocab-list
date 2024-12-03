import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/authentication/forgot_password.dart';
import '../../widgets/authentication/login_signup.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(isLoginProvider);
    final isForgotPassword = ref.watch(isForgotPasswordProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(200, 123, 123, 123)
                : Colors.transparent,
          ),
          const RiveAnimation.asset(
              'assets/animations/rive/sphere_animation.riv'),
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
                    padding: const EdgeInsets.fromLTRB(30.0, 20, 20, 30),
                    child: Text(
                      isForgotPassword
                          ? 'We got You!'
                          : isLogin
                              ? 'Login to get Started'
                              : 'Sign up to Proceed',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 40,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white10.withOpacity(0.65)
                              : Colors.white.withOpacity(0.65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.transparent,
                            ),
                          ),
                          margin: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 10),
                              child: isForgotPassword
                                  ? const ForgotPasswordWidget()
                                  : const LoginSignUpWidget(),
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
