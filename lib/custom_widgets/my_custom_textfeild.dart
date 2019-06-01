import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final String hint, label;
  final Icon icon;
  final bool isPassword;
  final Function onChange;
  final TextEditingController controller;
  final TextInputType keyType;

  MyTextFeild({
    this.hint,
    this.keyType,
    this.label,
    this.icon,
    this.onChange,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyType,
      controller: controller,
      onChanged: onChange,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        prefixIcon: icon,
      ),
    );
  }
}
