import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChipBackground extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const ChipBackground({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? primaryColor : whiteColor.withValues(alpha: 0.04);
    final border = selected ? const Color(0xFF4F8BFF) : const Color(0xFF2E3A4A);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: Text(label, style: defaultWhiteTextStyle),
      ),
    );
  }
}
