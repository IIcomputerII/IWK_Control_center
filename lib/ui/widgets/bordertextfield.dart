import 'package:flutter/material.dart';

class BorderTextField extends StatelessWidget {
  const BorderTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
    this.color = Colors.grey,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final IconData icon;
  final String labelText;
  final Color color;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );

    final OutlineInputBorder focusedStyle = borderStyle.copyWith(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: color,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: color, 
        ),
        labelStyle: TextStyle(
          color: color,
        ),
        enabledBorder: borderStyle,
        focusedBorder: focusedStyle,
        border: borderStyle,
      ),
    );
  }
}