import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_button.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_input.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_password_input.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.animationDuration,
    required this.isLogin,
    required this.size,
    required this.defaultLoginSize,
  });

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  static final formKey = GlobalKey<FormState>();

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late String error;

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: widget.size.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: LoginForm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 255,
                    child: Image.asset('assets/images/boxlogobold.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: mainDesignColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: const [
                            Text(
                              'Login to your account',
                              style: TextStyle(
                                fontSize: 15,
                                color: mainDesignColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RoundedInput(
                    icon: Icons.person,
                    hint: 'Email',
                    color: mainDesignColor,
                    formvalue: 'Email',
                    inputController: emailcontroller,
                  ),
                  RoundedPasswordInput(
                    hint: 'Password',
                    color: mainDesignColor,
                    inputController: passwordcontroller,
                  ),
                  const SizedBox(height: 10),
                  RoundedButton(
                    title: 'LOGIN',
                    color: mainDesignColor,
                    textColor: whiteDesignColor,
                    onTapEvent: () {
                      final isValidForm =
                          LoginForm.formKey.currentState!.validate();

                      if (isValidForm) {
                        signIn();
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'forgot password?',
                      style: TextStyle(
                        color: mainDesignColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void alertBanner(title, message, type, color) => Flushbar(
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        icon: type == 'Success'
            ? Icon(Icons.check_circle_rounded, size: 60, color: Colors.white)
            : Icon(Icons.error_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: title,
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: color,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

  // void alertBanner(message) => Flushbar(
  //       duration: Duration(seconds: 4),
  //       flushbarPosition: FlushbarPosition.TOP,
  //       icon: Icon(Icons.error_rounded, size: 60, color: Colors.white),
  //       shouldIconPulse: false,
  //       title: 'Error !!',
  //       message: message,
  //       borderRadius: BorderRadius.circular(25),
  //       margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
  //       backgroundColor: Color.fromARGB(255, 157, 37, 37),
  //       dismissDirection: FlushbarDismissDirection.VERTICAL,
  //     )..show(context);

  Future signIn() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: mainDesignColor),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      setState(() {
        error = e.message.toString();
      });
    }
    // Navigator.pop(context);
    if (error != '') {
      alertBanner(
        'Error !!',
        error,
        'Error',
        Color.fromARGB(255, 157, 37, 37),
      );
    } else {
      alertBanner(
        'Success !!',
        "Logged in successfully",
        'Success',
        Color.fromARGB(255, 47, 101, 114),
      );
    }
  }
}
