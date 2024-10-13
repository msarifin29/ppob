import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium!,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
    );
  }
}
