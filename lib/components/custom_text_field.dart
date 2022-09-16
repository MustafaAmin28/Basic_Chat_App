import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String hintText, labelText;
  IconButton? ico;
  bool hidden = false;

  Function(String)? onChange;
  String? Function(String?)? validate;
  CustomTextFormField({
    required this.hintText,
    required this.labelText,
    this.hidden = false,
    this.ico,
    this.onChange,
    this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validate,
        obscureText: hidden,
        onChanged: onChange,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          label: Text(
            labelText,
            style: const TextStyle(color: Colors.white),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: ico,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
