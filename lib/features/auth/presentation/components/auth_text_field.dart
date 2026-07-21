import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
