import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/presentation/screens/profile/widgets/dark_mode.dart';
import 'package:ayana_movies/presentation/screens/profile/widgets/profile_tile.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/mini_logo.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/locale/locale_cubit.dart';
import 'language_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notif = true;
  bool autoplay = true;

  String _localeLabel(Locale? locale) {
    final code = locale?.languageCode ?? 'en';
    switch (code) {
      case 'id':
        return 'Indonesian (ID)';
      case 'en':
        return 'English (US)';

      default:
        return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset('assets/images/ava_dedi.jpg', fit: BoxFit.cover)),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [bgColor.withValues(alpha: 0.15), bgColor.withValues(alpha: 0.55), bgColor],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MiniLogo(),
                        Text(context.t('profile'), style: defaultBigWhiteTextStyle),
                        SizedBox(width: 13.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(top: 16.h, bottom: 7.h),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: const AssetImage('assets/images/ava_dedi.jpg'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text('Dedi Kurniawan', style: defaultWhiteTextStyle),
                      SizedBox(height: 1.h),
                      Text('awanchaniago5@gmail.com', style: defaultSubWhiteTextStyle),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),

                ProfileTile(
                  icon: Icons.notifications_active_outlined,
                  title: context.t('notification'),
                  trailing: Switch(
                    value: notif,
                    activeColor: whiteColor,
                    activeTrackColor: primaryColor,
                    onChanged: (v) => setState(() => notif = v),
                  ),
                ),
                ProfileTile(
                  icon: Icons.grid_view_rounded,
                  title: context.t('language'),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocSelector<LocaleCubit, Locale?, String>(
                          selector: (state) => _localeLabel(state),
                          builder: (_, label) => Text(label, style: defaultDimTextStyle),
                        ),
                        SizedBox(width: 2.w),
                        Icon(Icons.chevron_right_rounded, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
                ProfileTile(
                  icon: Icons.videocam_outlined,
                  title: context.t('autoplay_videos'),
                  trailing: Switch(
                    value: autoplay,
                    activeColor: whiteColor,
                    activeTrackColor: primaryColor,
                    onChanged: (v) => setState(() => autoplay = v),
                  ),
                ),

                SizedBox(height: 2.h),

                DarkMode(),

                Padding(
                  padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
                  child: Divider(height: 28, thickness: 0.6, color: primaryColor),
                ),
                ProfileTile(
                  icon: Icons.description_outlined,
                  title: context.t('contact_support'),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
