import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/colors.dart';

class CircleIconBorder extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CircleIconBorder({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: whiteColor.withValues(alpha: 0.06),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: primaryColor),
          ),
        ),
      ),
    );
  }
}
