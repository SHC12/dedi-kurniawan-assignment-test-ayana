// ignore_for_file: unused_element_parameter

import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/chip_border_color.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/circle_icon.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/circle_icon_border.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/error_view.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/media_kind.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/is_favorite.dart';
import '../../../domain/usecases/is_favorite_tv.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import '../../../domain/usecases/toggle_favorite_tv.dart';
import '../../bloc/detail/detail_bloc.dart';
import '../shared/widgets/cached_image.dart';

class DetailUiState {
  final bool expanded;
  const DetailUiState({this.expanded = false});

  DetailUiState copyWith({bool? expanded, int? tabIndex}) => DetailUiState(expanded: expanded ?? this.expanded);
}

class DetailUiCubit extends Cubit<DetailUiState> {
  DetailUiCubit() : super(const DetailUiState());
  void toggleExpanded() => emit(state.copyWith(expanded: !state.expanded));
  void setTab(int i) => emit(state.copyWith(tabIndex: i));
}

class DetailScreen extends StatelessWidget {
  final int id;
  final MediaKind kind;
  const DetailScreen({super.key, required this.id, this.kind = MediaKind.movie});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DetailBloc(
            sl<GetMovieDetail>(),
            sl<ToggleFavorite>(),
            sl<IsFavorite>(),
            sl<GetTvDetail>(),
            sl<ToggleFavoriteTv>(),
            sl<IsFavoriteTv>(),
          )..add(LoadDetail(id, kind)),
        ),
        BlocProvider(create: (_) => DetailUiCubit()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            top: false,
            child: BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailLoading || state is DetailInitial) {
                  return const _DetailSkeleton();
                }
                if (state is DetailError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<DetailBloc>().add(LoadDetail(id, kind)),
                  );
                }
                final loaded = state as DetailLoaded;
                final vm = loaded.vm;

                final heroBackdrop = vm.backdropPath != null
                    ? '$kTmdbImageBaseUrl${vm.backdropPath}'
                    : (vm.posterPath != null ? '$kTmdbImageBaseUrl${vm.posterPath}' : null);

                final year = vm.year;
                final mediaKind = vm.kind == MediaKind.movie ? 'Movie' : 'TV';
                final ratingText = vm.vote?.toStringAsFixed(1);

                return BlocBuilder<DetailUiCubit, DetailUiState>(
                  builder: (context, ui) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 45.h,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: heroBackdrop == null
                                      ? Container(color: dimColor)
                                      : AppCachedImage(
                                          pathOrUrl: heroBackdrop,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                        ),
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          bgColor.withValues(alpha: 0.15),
                                          bgColor.withValues(alpha: 0.55),
                                          bgColor,
                                        ],
                                        stops: const [0.0, 0.55, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: MediaQuery.of(context).padding.top + 12,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleIcon(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),

                                Center(
                                  child: Container(
                                    width: 30.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor.withValues(alpha: 0.10),
                                      border: Border.all(color: whiteColor.withValues(alpha: 0.12)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withValues(alpha: 0.30),
                                          blurRadius: 30,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 3.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(vm.title, textAlign: TextAlign.center, style: defaultBigWhiteTextStyle),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleIconBorder(icon: Icons.play_arrow_outlined, onTap: () {}),
                                CircleIconBorder(
                                  icon: loaded.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                  onTap: () => context.read<DetailBloc>().add(ToggleFavoriteEvent()),
                                ),
                                CircleIconBorder(icon: Icons.ios_share_rounded, onTap: () {}),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 3.h)),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 8,
                              children: [
                                if (year != null) ChipBorderColor(text: year),
                                if (ratingText != null) ChipBorderColor(text: '⭐ $ratingText'),
                                ChipBorderColor(text: mediaKind),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _ExpandableText(
                              expanded: ui.expanded,
                              onToggle: context.read<DetailUiCubit>().toggleExpanded,
                              text: vm.overview ?? '-',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandableText extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;
  const _ExpandableText({required this.text, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final body = Text(
      text.isEmpty ? '-' : text,
      maxLines: expanded ? null : 3,
      overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      style: defaultSubWhiteTextStyle,
      textAlign: TextAlign.left,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        body,
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onToggle,
          child: Text(expanded ? context.t('read_less') : context.t('read_more'), style: defaultSubWhiteTextStyle),
        ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(height: 430, color: Colors.white12),
        const SizedBox(height: 12),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _ShimmerBox(width: 220, height: 22)),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _ShimmerBox(width: double.infinity, height: 70),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _ShimmerBox(width: double.infinity, height: 44),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const _ShimmerBox({required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(radius)),
    );
  }
}
