import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

smallText({text, color, fontWeight, double? fontSize, textAlign, overflow}) {
  return Text(text,
      overflow: overflow,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize));
}

class CustomTextFormField extends StatelessWidget {
  final String? labelText;

  final bool? obscureText;
  final TextEditingController controller;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? focusErrorBorder;
  final Widget? suffixIcon;
  final String? hintText;
  final String? validateMsg;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.onChanged,
    this.obscureText,
    this.enabledBorder,
    this.focusedBorder,
    this.focusErrorBorder,
    this.suffixIcon,
    this.validateMsg,
    this.keyboardType,
    this.inputFormatters,
    required Icon prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validateMsg ?? 'value is empty';
        } else {
          return null;
        }
      },
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          fillColor: Colors.grey[200],
          filled: true,
          border: InputBorder.none,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: focusErrorBorder),
    );
  }
}

class TextWidget {
  text({data, size, weight, color}) {
    return Text(
      data,
      style:
          GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color),
      overflow: TextOverflow.ellipsis,
    );
  }
}
