import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/loginRegister/loginregisterComponents/input_container.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
    required this.hint,
    required this.color,
    this.onTapValue,
    this.onChangedValue,
    required this.enabled,
    required this.inputController,
  });

  final String hint;
  final Color color;
  final onTapValue;
  final onChangedValue;
  final bool enabled;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onTap: onTapValue,
        enabled: enabled,
        controller: inputController,
        autofocus: false,
        cursorColor: color,
        style: TextStyle(color: color),
        onChanged: onChangedValue,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.search_rounded,
              color: color,
            ),
          ),
          prefixIconColor: color,
          hintText: hint,
          hintStyle: TextStyle(color: color, fontSize: 15),
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
