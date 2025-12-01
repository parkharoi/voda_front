
import 'package:flutter/material.dart';
import 'package:voda_front/common/app_colors.dart';

class VodaButten extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const VodaButten({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = false,
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}