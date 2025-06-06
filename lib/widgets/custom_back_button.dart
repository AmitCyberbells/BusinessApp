import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Image.asset(
        'assets/images/back_arrow.png',
        width: size,
        height: size,
      ),
    );
  }
}
