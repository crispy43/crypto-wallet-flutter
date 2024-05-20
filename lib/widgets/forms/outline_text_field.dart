import 'package:flutter/material.dart';

class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    Key? key,
    this.initialValue,
    this.keyboardType,
    this.backgroundColor,
    this.autoFocus,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.fontSize,
  }) : super(key: key);

  final String? initialValue;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final bool? autoFocus;
  final String? placeholder;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      autofocus: autoFocus ?? true,
      onChanged: onChanged,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        filled: (backgroundColor != null),
        fillColor: backgroundColor,
        hintText: placeholder,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: TextStyle(
          fontSize: fontSize ?? 14.0,
          color: const Color(0xffc1c1c1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffc1c1c1), width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffc1c1c1), width: 1.0),
        ),
      ),
    );
  }
}
