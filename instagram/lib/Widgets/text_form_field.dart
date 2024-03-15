import "package:flutter/material.dart";

class TextEditingForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool ispass;
  final String hinttext;
  const TextEditingForm(
      {super.key,
      required this.textEditingController,
      required this.textInputType,
      this.ispass = false,
      required this.hinttext});

  @override
  Widget build(BuildContext context) {
    final InputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hinttext,
          border: InputBorder,
          focusedBorder: InputBorder,
          enabledBorder: InputBorder,
          filled: true,
          contentPadding: EdgeInsets.all(8)),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}
