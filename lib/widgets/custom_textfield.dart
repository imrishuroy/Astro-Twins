import 'package:flutter/material.dart';

final _border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
);

class CustomTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;
  final bool isphoneNoField;
  final TextInputType inputType;
  final String? Function(String? value) validator;
  final bool isPassowrdField;
  final Widget? suffixIcon;
  final bool isEnabled;
  final String? initialValue;
  final int? maxLines;
  final int? maxLength;
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.inputType,
    this.isPassowrdField = false,
    this.suffixIcon,
    required this.validator,
    this.isphoneNoField = false,
    this.isEnabled = true,
    this.initialValue,
    this.maxLength,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // maxLines: maxLines,
      // maxLength: maxLength,
      enabled: isEnabled,
      initialValue: initialValue,
      obscureText: isPassowrdField,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(10),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        disabledBorder: _border,
        hintText: hintText,
      ),
    );
  }
}
