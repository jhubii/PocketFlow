import 'dart:io';
import 'dart:math';

import 'package:PocketFlow/content/components/rounded_button.dart';
import 'package:PocketFlow/content/components/rounded_input.dart';
import 'package:PocketFlow/content/components/rounded_password_input.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Profile extends StatefulWidget {
  Profile({
    super.key,
    required this.user,
  });

  Users user;
  bool showpass = false;
  static final formKey = GlobalKey<FormState>();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController newpasswordcontroller;
  late TextEditingController oldpasswordcontroller;
  late TextEditingController fnamecontroller;
  late TextEditingController lnamecontroller;
  late String error;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    oldpasswordcontroller = TextEditingController();
    newpasswordcontroller = TextEditingController();
    fnamecontroller = TextEditingController(text: widget.user.firstname);
    lnamecontroller = TextEditingController(text: widget.user.lastname);
    error = "";
  }

  @override
  void dispose() {
    oldpasswordcontroller.dispose();
    newpasswordcontroller.dispose();
    fnamecontroller.dispose();
    lnamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(widget.user);
  }

  Widget buildContent(Users user) => Center(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    color: const Color.fromARGB(32, 71, 105, 104)),
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
              top: 350,
              left: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    color: const Color.fromARGB(27, 54, 93, 91)),
              ),
            ),
            Column(
              children: [
                appBarContent(user),
                profilePic(user),
                const SizedBox(height: 25),
                userInfo(user),
              ],
            ),
          ],
        ),
      );

  appBarContent(Users user) => Container(
        padding:
            const EdgeInsets.only(top: 45, left: 22, bottom: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your',
                  style: TextStyle(
                    color: mainDesignColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Credentials',
                  style: TextStyle(
                    color: mainDesignColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      );

  profilePic(Users user) => Stack(
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(250),
              color: mainDesignColor,
            ),
            child: user.image == '-'
                ? imgNotExist()
                : GestureDetector(
                    onTap: () {
                      popupProfilePic(user.id);
                    },
                    child: realtimeDataImage(user.id, 'image'),
                  ),
          ),
          Positioned(
            top: 135,
            right: 10,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.white),
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(255, 117, 143, 145),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: whiteDesignColor,
                ),
                onPressed: () {
                  selectFile();
                },
              ),
            ),
          ),
        ],
      );

  userInfo(Users user) => Expanded(
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        size: 40,
                        color: mainDesignColor,
                      ),
                      title: Text(
                        user.email,
                        style: mainStyle,
                      ),
                      subtitle: const Text(
                        'Email',
                        style: labelStyle,
                      ),
                      dense: true,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.face_rounded,
                        size: 40,
                        color: mainDesignColor,
                      ),
                      title: realtimeData(user.id, 'firstname', mainStyle),
                      subtitle: const Text(
                        'First Name',
                        style: labelStyle,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          popupEdit(
                            'First Name',
                            fnamecontroller,
                            user,
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: mainDesignColor,
                        ),
                      ),
                      dense: true,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.family_restroom_rounded,
                        size: 40,
                        color: mainDesignColor,
                      ),
                      title: realtimeData(user.id, 'lastname', mainStyle),
                      subtitle: const Text(
                        'Last Name',
                        style: labelStyle,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          popupEdit(
                            'Last Name',
                            lnamecontroller,
                            user,
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: mainDesignColor,
                        ),
                      ),
                      dense: true,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              popUpPassword('Password', user);
                            },
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              popUpConfirmationReset(user.id);
                            },
                            child: const Text(
                              'Reset Data',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                RoundedButton(
                  title: 'Sign Out',
                  color: mainDesignColor,
                  textColor: whiteDesignColor,
                  onTapEvent: () {
                    popUpLogoutConfirmation();
                  },
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ],
        ),
      );

  popupEdit(String editTitle, TextEditingController inputController,
          Users user) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 200,
            height: 220,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(61, 71, 105, 104)),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(101, 54, 93, 91)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Change $editTitle',
                        style: const TextStyle(
                          color: mainDesignColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: Profile.formKey,
                        child: RoundedInput(
                          hint: 'Enter new $editTitle',
                          color: mainDesignColor,
                          formvalue: editTitle,
                          inputController: inputController,
                          enabled: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              final isValidForm =
                                  Profile.formKey.currentState!.validate();

                              if (isValidForm) {
                                Navigator.pop(context);
                                popUpConfirmation(
                                    editTitle, inputController, user.id);
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showData(editTitle, inputController);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popupProfilePic(id) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          contentPadding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          content: SizedBox(
            width: 150,
            height: 325,
            child: Column(
              children: [
                realtimeDataImageView(id, 'image'),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainDesignColor),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: whiteDesignColor,
                              fontSize: 14,
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
      );

  popupUploadImage() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          contentPadding: const EdgeInsets.all(5),
          content: SizedBox(
            width: 150,
            height: 350,
            child: Column(
              children: [
                if (pickedFile != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            popupConfirmationProfileEdit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainDesignColor,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Upload image',
                              style: TextStyle(
                                color: whiteDesignColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            selectFile();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainDesignColor),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Choose image',
                              style: TextStyle(
                                color: whiteDesignColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainDesignColor),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: whiteDesignColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  popUpPassword(String editTitle, Users user) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 200,
            height: 340,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(61, 71, 105, 104)),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(101, 54, 93, 91)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Change $editTitle',
                        style: const TextStyle(
                          color: mainDesignColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: Profile.formKey,
                        child: Column(
                          children: [
                            RoundedPasswordInput(
                                hint: 'Enter current $editTitle',
                                color: mainDesignColor,
                                inputController: oldpasswordcontroller),
                            RoundedPasswordInput(
                                hint: 'Enter new $editTitle',
                                color: mainDesignColor,
                                inputController: newpasswordcontroller),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              final isValidForm =
                                  Profile.formKey.currentState!.validate();

                              if (isValidForm) {
                                Navigator.pop(context);
                                popUpConfirmation(
                                    editTitle, newpasswordcontroller, user.id);
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                newpasswordcontroller.text = '';
                                oldpasswordcontroller.text = '';
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popupConfirmationProfileEdit() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 100,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(57, 232, 212, 145)),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 249, 220, 162)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                          child: FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: Color.fromARGB(255, 244, 158, 54),
                        size: 50,
                      )),
                      const Text(
                        "Are you sure you want to update your profile picture?",
                        style: TextStyle(
                          color: mainDesignColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              uploadFile();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popUpLogoutConfirmation() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 100,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(57, 244, 222, 150)),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 238, 204, 137)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                          child: FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: Color.fromARGB(255, 244, 158, 54),
                        size: 50,
                      )),
                      const Text(
                        "Are you sure you wan't to Sign out?",
                        style: TextStyle(
                          color: mainDesignColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popUpConfirmation(
          String editTitle, TextEditingController inputController, String id) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 100,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(57, 244, 222, 150)),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 238, 204, 137)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                          child: FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: Color.fromARGB(255, 244, 158, 54),
                        size: 50,
                      )),
                      Text(
                        "Are you sure you wan't to update your $editTitle to ${inputController.text}?",
                        style: const TextStyle(
                          color: mainDesignColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (editTitle == 'Password') {
                                Navigator.pop(context);
                                changeAuthPassword(oldpasswordcontroller.text,
                                    newpasswordcontroller.text);
                              } else if (editTitle == 'First Name') {
                                updateFname(id);
                              } else if (editTitle == 'Last Name') {
                                updateLname(id);
                              }
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showData(editTitle, inputController);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popUpConfirmationReset(String id) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: SizedBox(
            width: 100,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(75, 247, 212, 142)),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 249, 220, 161)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleQuestion,
                          color: Color.fromARGB(255, 244, 158, 54),
                          size: 50,
                        ),
                        const Text(
                          "Are you sure you want to delete all Transactions? This process cannot be undone",
                          style: TextStyle(
                            color: mainDesignColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                resetData(id);
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  showData(editTitle, TextEditingController inputController) {
    var collection = FirebaseFirestore.instance.collection('Users');
    collection.doc(widget.user.id).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        if (editTitle == 'First Name') {
          inputController.text = data['firstname'];
        } else if (editTitle == 'Last Name') {
          inputController.text = data['lastname'];
        }
      }
    });
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

//Upload Image ---------------------------------------------------------------

  Widget imgNotExist() => const Icon(
        Icons.person,
        color: whiteDesignColor,
        size: 120,
      );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });

    popupUploadImage();
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)])
        .join();
  }

  Future uploadFile() async {
    final path = 'files/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: const Color.fromARGB(255, 40, 159, 182),
          size: 70,
        ),
      ),
    );

    try {
      setState(() {
        uploadTask = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');

    updateUserImage(widget.user.id, urlDownload);

    setState(() {
      uploadTask = null;
    });

    Navigator.of(context).pop();
  }

  Widget realtimeDataImage(id, info) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        }
        var userDocument = snapshot.data;
        return CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(userDocument![info]),
        );
      },
    );
  }

  Widget realtimeDataImageView(id, info) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        }
        var userDocument = snapshot.data;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: Image.network(userDocument![info]),
            ),
          ),
        );
      },
    );
  }

//CRUD for Credentials --------------------------------------------------------

  updateFname(String id) {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    docUser.update({
      'firstname': fnamecontroller.text,
    });

    Navigator.pop(context);
    alertBanner(
      'Success !!',
      "Firstname has been updated",
      'Success',
      const Color.fromARGB(255, 47, 101, 114),
    );
  }

  updateLname(String id) {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    docUser.update({
      'lastname': lnamecontroller.text,
    });

    Navigator.pop(context);
    alertBanner(
      'Success !!',
      "Lastname has been updated",
      'Success',
      const Color.fromARGB(255, 47, 101, 114),
    );
  }

  Widget realtimeData(id, info, style) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        }
        var userDocument = snapshot.data;
        return Text(
          userDocument![info].toString(),
          style: style,
        );
      },
    );
  }

  updatePassword(String id) {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    docUser.update({
      'password': newpasswordcontroller.text,
    });
  }

  void changeAuthPassword(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email.toString(), password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        updatePassword(user.uid);
        user.reload();
        FirebaseAuth.instance.signOut();
        alertBanner(
          'Success !!',
          "Password has been updated",
          'Success',
          const Color.fromARGB(255, 47, 101, 114),
        );
      }).catchError((error) {
        setState(() {
          newpasswordcontroller.text = "";
          oldpasswordcontroller.text = "";
        });
        alertBanner(
          'Error !!',
          error,
          'Error',
          const Color.fromARGB(255, 157, 37, 37),
        );
      });
    }).catchError((err) {
      setState(() {
        newpasswordcontroller.text = "";
        oldpasswordcontroller.text = "";
      });
      alertBanner(
        'Error !!',
        err.toString(),
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    });
  }

  resetData(String id) async {
    batchDelete(id);
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.id);

    docUser.update({
      'totalIncome': 0.00,
      'totalExpense': 0.00,
      'balance': 0.00,
      'cat1': 0.00,
      'cat2': 0.00,
      'cat3': 0.00,
      'cat4': 0.00,
      'cat5': 0.00,
    });
  }

  Future<void> batchDelete(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final transactions = FirebaseFirestore.instance
        .collection('Transactions')
        .where('userID', isEqualTo: id);
    return transactions.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
        alertBanner(
          'Success !!',
          "Data has been Reset",
          'Success',
          const Color.fromARGB(255, 47, 101, 114),
        );
      }
      return batch.commit();
    });
  }

  Future updateUserImage(String id, String image) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    await docUser.update({
      'image': image,
    });

    alertBanner(
      'Success !!',
      "Profile picture has been updated",
      'Success',
      const Color.fromARGB(255, 47, 101, 114),
    );
  }
}
