import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typhography.dart';

class ChipBorderColor extends StatelessWidget {
  final String text;
  const ChipBorderColor({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: Text(text, style: defaultSubDimTextStyle),
    );
  }
}
