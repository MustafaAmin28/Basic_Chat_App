import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final double width, height;
  final Color? buttonColor;
  VoidCallback? onTap;
  CustomElevatedButton(
      {required this.buttonText,
      required this.height,
      required this.width,
      required this.buttonColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        primary: buttonColor,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(color: Color(0xff2B475E)),
      ),
    );
  }
}
