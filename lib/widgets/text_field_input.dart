import 'package:flutter/material.dart';
import 'package:uni_link/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {Key? key,
      this.isPass = false,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType})
      : super(key: key);
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: textEditingController,
      style: const TextStyle(color: Color(0xFFEAEAEB)),
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
