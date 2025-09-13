import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/explore/explore_bloc.dart';

class ActiveChipFilter extends StatelessWidget {
  const ActiveChipFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, s) {
          final chips = <Widget>[];
          if (s.category != 'All') {
            chips.add(
              _ActiveChip(
                label: s.category,
                onClear: () {
                  context.read<ExploreBloc>().add(
                    ExploreApplyFilter(
                      category: 'All',
                      genres: s.genres,
                      year: s.year,
                      country: s.country,
                      sortBy: s.sortBy,
                    ),
                  );
                },
              ),
            );
          }
          if (s.genres.isNotEmpty) {
            chips.add(
              _ActiveChip(
                label: s.genres.join(', '),
                onClear: () {
                  context.read<ExploreBloc>().add(
                    ExploreApplyFilter(
                      category: s.category,
                      genres: {},
                      year: s.year,
                      country: s.country,
                      sortBy: s.sortBy,
                    ),
                  );
                },
              ),
            );
          }

          if (s.sortBy != 'Recommended') {
            chips.add(
              _ActiveChip(
                label: s.sortBy,
                onClear: () {
                  context.read<ExploreBloc>().add(
                    ExploreApplyFilter(
                      category: s.category,
                      genres: s.genres,
                      year: s.year,
                      country: s.country,
                      sortBy: 'Recommended',
                    ),
                  );
                },
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chips),
          );
        },
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;
  const _ActiveChip({required this.label, required this.onClear});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: whiteColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: whiteColor.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: defaultSubDimTextStyle),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 16, color: dimColor),
          ),
        ],
      ),
    );
  }
}
