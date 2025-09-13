// ignore_for_file: use_build_context_synchronously

import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/chip_background.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../domain/entities/filter.dart';
import '../../../bloc/explore/explore_bloc.dart';

class SearchFilter extends StatelessWidget {
  SearchFilter({super.key});

  final TextEditingController _searchCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: whiteColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 2.w),
                      const Icon(Icons.search, color: dimColor),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: TextField(
                          controller: _searchCtl,
                          style: TextStyle(color: whiteColor),
                          cursorColor: dimColor,
                          decoration: InputDecoration(
                            hintText: context.t('search_hint'),
                            hintStyle: defaultSubDimTextStyle,
                            border: InputBorder.none,
                          ),
                          onChanged: (q) => context.read<ExploreBloc>().add(ExploreQueryChanged(q)),
                        ),
                      ),
                      BlocBuilder<ExploreBloc, ExploreState>(
                        builder: (context, s) {
                          final hasQuery = switch (s) {
                            ExploreLoaded(:final query) => query.isNotEmpty,
                            ExploreSearching(:final query) => query.isNotEmpty,
                            ExploreEmpty(:final query) => query.isNotEmpty,
                            _ => false,
                          };
                          if (!hasQuery) return SizedBox(width: 2.w);
                          return IconButton(
                            icon: const Icon(Icons.close_rounded, color: dimColor),
                            onPressed: () {
                              final f = FocusManager.instance.primaryFocus;
                              if (f != null && f.hasFocus) f.unfocus();
                              _searchCtl.clear();
                              context.read<ExploreBloc>().add(const ExploreQueryChanged(''));
                              Future.microtask(() => FocusManager.instance.primaryFocus?.unfocus());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  color: whiteColor.withValues(alpha: 0.08),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      final s = context.read<ExploreBloc>().state;
                      final initial = FilterModel(
                        category: s.category,
                        genres: s.genres,
                        year: s.year,
                        country: s.country,
                        sortBy: s.sortBy,
                      );
                      final r = await showModalBottomSheet<FilterModel>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => FilterBottomSheet(initial: initial),
                      );
                      if (r != null) {
                        context.read<ExploreBloc>().add(
                          ExploreApplyFilter(
                            category: r.category,
                            genres: r.genres,
                            year: r.year,
                            country: r.country,
                            sortBy: r.sortBy,
                          ),
                        );
                      }
                    },
                    child: const SizedBox(width: 48, height: 48, child: Icon(Icons.tune_rounded, color: dimColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final FilterModel initial;
  const FilterBottomSheet({super.key, required this.initial});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterModel f;

  @override
  void initState() {
    super.initState();
    f = widget.initial.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: whiteColor.withValues(alpha: 0.06)),
        ),
        padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.w),
        child: Column(
          children: [
            Container(
              width: 20.w,
              height: 0.5.h,
              decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(12)),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  _SectionTitle(context.t('category')),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final c in const ['All', 'Movies', 'TV'])
                        ChipBackground(
                          label: c,
                          selected: f.category == c,
                          onTap: () => setState(() => f = f.copyWith(category: c)),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  _SectionTitle(context.t('genre')),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final g in const ['Action', 'Comedy', 'Romance', 'Thriller', 'Sci-Fi', 'Drama', 'Fantasy'])
                        ChipBackground(
                          label: g,
                          selected: f.genres.contains(g),
                          onTap: () => setState(() {
                            final s = {...f.genres};
                            s.contains(g) ? s.remove(g) : s.add(g);
                            f = f.copyWith(genres: s);
                          }),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  _Tile(
                    icon: Icons.sort_rounded,
                    title: context.t('sort_by'),
                    trailing: _DropdownMini<String>(
                      value: f.sortBy,
                      items: ['Recommended', 'Latest', 'Top Rated'],
                      labelBuilder: (v) => v,
                      onChanged: (v) => setState(() => f = f.copyWith(sortBy: v)),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            side: BorderSide(color: greyColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            foregroundColor: Colors.white,
                            backgroundColor: whiteColor.withValues(alpha: 0.04),
                          ),
                          onPressed: () => setState(() => f = FilterModel.initial()),
                          child: Text(context.t('reset'), style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                      SizedBox(width: 4.h),
                      Expanded(
                        child: _GradientButton(label: context.t('apply'), onPressed: () => Navigator.pop(context, f)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F8BFF), Color(0xFF00D4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: defaultDimTextStyle),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  const _Tile({required this.icon, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: whiteColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: whiteColor.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          SizedBox(width: 2.w),
          Expanded(child: Text(title, style: defaultWhiteTextStyle)),
          trailing,
        ],
      ),
    );
  }
}

class _DropdownMini<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;
  const _DropdownMini({required this.value, required this.items, required this.labelBuilder, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem<T>(
                value: e,
                child: Text(labelBuilder(e), style: defaultSubWhiteTextStyle),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null || T == int) onChanged(v as T);
        },
        dropdownColor: const Color(0xFF141A23),
        borderRadius: BorderRadius.circular(12),
        iconEnabledColor: Colors.white70,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
