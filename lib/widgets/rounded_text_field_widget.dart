import 'package:flutter/material.dart';

class RoundedTextFieldWidget extends StatelessWidget {
  const RoundedTextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputAction,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      validator: validator,
    );
  }
}
