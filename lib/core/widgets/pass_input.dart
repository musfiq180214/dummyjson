import 'package:dummyjson/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:dummyjson/core/theme/colors.dart';

class PassInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength; // optional, allow unlimited if null

  const PassInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength,
  });

  @override
  State<PassInputField> createState() => _PassInputFieldState();
}

class _PassInputFieldState extends State<PassInputField> {
  bool _obscureText = true;

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: primaryColor.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: _toggleObscure,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        }
        return null;
      },
    );
  }
}
