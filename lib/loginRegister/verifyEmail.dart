import 'dart:async';

import 'package:PocketFlow/content/home.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_button.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
      alertBanner(
        'Success !!',
        "Email has been Verified. Welcome to PocketFlow",
        'Success',
        const Color.fromARGB(255, 47, 101, 114),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      emailsentBanner(
        'Email Sent',
        'Verification email sent to ${user.email}',
        'Success',
        const Color.fromARGB(255, 63, 108, 113),
      );
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(
        const Duration(
          seconds: 60,
        ),
        () {
          setState(() {
            canResendEmail = true;
          });
          print(canResendEmail.toString());
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Home()
      : Scaffold(
          backgroundColor: whiteDesignColor,
          body: Stack(
            children: [
              Positioned(
                top: 150,
                right: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: gradientDesignColor),
                ),
              ),
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: gradientDesignColor),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Image.asset(
                          'assets/images/logobold.png',
                          height: 170,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "We have sent you an email.",
                        style: mainStyle,
                      ),
                      const Text(
                        "Please verify your account.",
                        style: mainStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      resentVerification(),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => FirebaseAuth.instance.signOut(),
                        child: const Text(
                          'Cancel',
                          style: mainStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

  Widget resentVerification() => Row(
        children: [
          Expanded(
            child: RoundedButton(
                title: 'Resend Email',
                color: mainDesignColor,
                textColor: whiteDesignColor,
                onTapEvent: () {
                  canResendEmail
                      ? sendVerificationEmail()
                      : alertBanner(
                          'Error !!',
                          'Please wait for a few second for another verification email',
                          'Error',
                          const Color.fromARGB(255, 157, 37, 37),
                        );
                }),
          ),
        ],
      );

  void alertBanner(title, message, type, color) => Flushbar(
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        icon: type == 'Success'
            ? const Icon(Icons.check_circle_rounded,
                size: 60, color: Colors.white)
            : const Icon(Icons.error_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: title,
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: color,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

  void emailsentBanner(title, message, type, color) => Flushbar(
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.email_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: title,
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: color,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);
}
