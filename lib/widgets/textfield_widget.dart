import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText, labelText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final Function()? suffixOnTap;
  final controller;
  final keyboardType;
  final validator;
  final bool autoFocus;

  const TextFieldWidget({
    this.hintText,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText = false,
    this.suffixOnTap,
    this.controller,
    this.keyboardType = TextInputType.text,
    @required this.validator,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.teal),
        focusColor: Theme.of(context).primaryColor,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: (labelText == null) ? hintText : labelText,
        hintText: (labelText == null) ? null : hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: GestureDetector(
          onTap: suffixOnTap,
          child: Icon(
            suffixIconData,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      autofocus: autoFocus,
      validator: validator,
    );
  }
}
