import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/input_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordInput extends StatefulWidget {
  const RoundedPasswordInput({
    super.key,
    required this.hint,
    required this.color,
    required this.inputController,
  });

  final String hint;
  final Color color;
  final TextEditingController inputController;

  @override
  State<RoundedPasswordInput> createState() => _RoundedPasswordInputState();
}

class _RoundedPasswordInputState extends State<RoundedPasswordInput> {
  bool showpass = true;
  String password = '';

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextFormField(
        controller: widget.inputController,
        validator: (value) {
          if (value == '') {
            return "Password can't be empty";
          } else if (value!.length < 8) {
            return "Password should have atleast 8 characters";
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() => password = value),
        cursorColor: widget.color,
        obscureText: showpass,
        style: TextStyle(color: widget.color),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Icon(
              Icons.lock_person_rounded,
              color: widget.color,
            ),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: widget.color),
          filled: true,
          fillColor: textFieldColor.withAlpha(50),
          contentPadding: const EdgeInsets.only(left: 15, top: 20, bottom: 15),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  showpass = !showpass;
                });
              },
              icon: showpass
                  ? Icon(
                      Icons.visibility,
                      color: widget.color,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: widget.color,
                    ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
