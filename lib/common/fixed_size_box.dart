import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voda_front/common/app_colors.dart';

enum ItemSize{S, L}

class FixedSizeBox extends StatelessWidget {
  final ItemSize size;
  final String label;

  const FixedSizeBox({
    super.key,
    required this.size,
    required this.label,
});

  @override
  Widget build(BuildContext context) {
    const double sWidth = 100.0;
    const double sHeight = 100.0;
    const double sFontSize = 15.0;

    const double lWidth = 200.0;
    const double lHeight = 200.0;
    const double lFontSize = 24.0;

    final double width = (size == ItemSize.S) ? sWidth : lWidth;
    final double height = (size == ItemSize.S) ? sHeight : lHeight;
    final double fontSize = (size == ItemSize.S) ? sFontSize : lFontSize;
    final Color color = (size == ItemSize.S) ? AppColors.primary : AppColors.secondaryPink;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        '$label\n(${size.name})',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
