import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MiniLogo extends StatelessWidget {
  const MiniLogo();
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 13.w, height: 6.h, child: Image.asset('assets/images/ayana.png'));
  }
}
