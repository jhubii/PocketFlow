import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_button.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_input.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/rounded_password_input.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  });

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  static final formKey = GlobalKey<FormState>();

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController firstnamecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController phonenumcontroller;
  late String error;

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    firstnamecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    phonenumcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: RegisterForm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: SizedBox(
                        height: 210,
                        child: Image.asset('assets/images/logowhitebold.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: const [
                          Text(
                            'Create your Account',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: RoundedInput(
                              icon: Icons.face_rounded,
                              hint: 'Firstname',
                              color: whiteDesignColor,
                              formvalue: 'Firstname',
                              inputController: firstnamecontroller,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: RoundedInput(
                              icon: Icons.family_restroom_rounded,
                              hint: 'Lastname',
                              color: whiteDesignColor,
                              formvalue: 'Lastname',
                              inputController: lastnamecontroller,
                            ),
                          )
                        ],
                      ),
                    ),
                    RoundedInput(
                      icon: Icons.person,
                      hint: 'Email',
                      color: whiteDesignColor,
                      formvalue: 'Email',
                      inputController: emailcontroller,
                    ),
                    RoundedPasswordInput(
                      hint: 'Password',
                      color: whiteDesignColor,
                      inputController: passwordcontroller,
                    ),
                    const SizedBox(height: 10),
                    RoundedButton(
                      title: 'SIGN UP',
                      color: whiteDesignColor,
                      textColor: mainDesignColor,
                      onTapEvent: () {
                        final isValidForm =
                            RegisterForm.formKey.currentState!.validate();

                        if (isValidForm) {
                          registerUser();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void alertBanner(message) => Flushbar(
        duration: Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(Icons.error_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: 'Error !!',
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: Color.fromARGB(255, 157, 37, 37),
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

  Future registerUser() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: mainDesignColor,
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      createUser();

      setState(() {
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
    }
    Navigator.pop(context);
    if (error != '') {
      alertBanner(error);
    }
  }

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users').doc(userid);

    final newUser = Users(
      id: userid,
      email: emailcontroller.text,
      password: passwordcontroller.text,
      firstname: firstnamecontroller.text,
      lastname: lastnamecontroller.text,
      image: '-',
      balance: 0,
      totalExpense: 0,
      totalIncome: 0,
    );

    final json = newUser.toJson();
    await docUser.set(json);

    Navigator.pop(context);
  }
}
