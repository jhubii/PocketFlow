import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/input_container.dart';
import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    super.key,
    required this.icon,
    required this.hint,
    required this.color,
    required this.formvalue,
    required this.inputController,
  });

  final IconData icon;
  final String hint;
  final Color color;
  final String formvalue;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextFormField(
        controller: inputController,
        validator: (value) {
          if (value == '') {
            return "$formvalue can't be empty";
          } else {
            return null;
          }
        },
        autofocus: false,
        cursorColor: color,
        style: TextStyle(color: color),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          prefixIconColor: color,
          hintText: hint,
          hintStyle: TextStyle(color: color),
          filled: true,
          fillColor: textFieldColor.withAlpha(50),
          contentPadding: const EdgeInsets.only(left: 15, top: 20, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
