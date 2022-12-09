import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/input_container.dart';
import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    super.key,
    required this.hint,
    required this.color,
    required this.formvalue,
    required this.enabled,
    required this.inputController,
  });

  final String hint;
  final Color color;
  final String formvalue;
  final bool enabled;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextFormField(
        enabled: enabled,
        controller: inputController,
        validator: (value) {
          if (value == '') {
            return 'Enter $formvalue';
          } else {
            return null;
          }
        },
        autofocus: false,
        cursorColor: color,
        style: TextStyle(color: color),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: color),
          filled: true,
          fillColor: textFieldColor.withAlpha(50),
          contentPadding: const EdgeInsets.only(left: 30, top: 20, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
