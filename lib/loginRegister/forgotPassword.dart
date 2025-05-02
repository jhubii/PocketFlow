import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_button.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_input.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  bool canReSendResetPassEmail = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 120,
        leading: Expanded(
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: const Text(
              'Go Back',
              style: mainStyle,
            ),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 21,
              color: mainDesignColor,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(128, 71, 105, 104)),
            ),
          ),
          Positioned(
            top: 150,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(101, 54, 93, 91)),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(27, 54, 93, 91)),
            ),
          ),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/boxlogobold.png',
                        height: 250,
                      ),
                      const Text("Change your password.", style: mainStyle),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedInput(
                        icon: Icons.email_rounded,
                        hint: 'Type your Email',
                        color: mainDesignColor,
                        formvalue: 'Email',
                        inputController: emailcontroller,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      resetPass(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget resetPass() => Row(
        children: [
          Expanded(
            child: RoundedButton(
                title: 'Resend Email',
                color: mainDesignColor,
                textColor: whiteDesignColor,
                onTapEvent: () {
                  final isValidForm = formKey.currentState!.validate();
                  if (isValidForm == true) {
                    canReSendResetPassEmail
                        ? resetPassword()
                        : alertBanner(
                            'Error !!',
                            'Please wait for a few second for another verification email',
                            'Error',
                            const Color.fromARGB(255, 157, 37, 37),
                          );
                  }
                }),
          ),
        ],
      );

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailcontroller.text.trim(),
      );
      Navigator.pop(context);
      emailsentBanner(
        'Email sent',
        'Password reset email sent.',
        const Color.fromARGB(255, 63, 108, 113),
      );
    } on FirebaseAuthException catch (e) {
      alertBanner(
        'Error !!',
        e.message,
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    }
  }

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

  void emailsentBanner(title, message, color) => Flushbar(
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
