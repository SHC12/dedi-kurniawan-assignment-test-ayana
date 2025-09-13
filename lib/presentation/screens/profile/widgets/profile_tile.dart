import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/colors.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  const ProfileTile({required this.icon, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: primaryColor,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 4.w),
            Expanded(child: Text(title, style: defaultWhiteTextStyle)),
            trailing,
          ],
        ),
      ),
    );
  }
}
