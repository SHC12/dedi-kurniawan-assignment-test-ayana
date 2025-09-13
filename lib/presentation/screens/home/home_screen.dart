// ignore_for_file: unused_element_parameter

import 'package:ayana_movies/presentation/screens/home/widgets/home_hero.dart';
import 'package:ayana_movies/presentation/screens/home/widgets/popular_movies_section.dart';
import 'package:ayana_movies/presentation/screens/home/widgets/popular_tv_section.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../bloc/movie_list/movie_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: bgColor,
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: bgColor,
          onRefresh: () async {
            context.read<MovieListBloc>().add(const LoadPopular(forceRefresh: true));
          },
          child: BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) {
              if (state is MovieListLoading || state is MovieListInitial) {
                return const _HomeSkeleton();
              }
              if (state is MovieListError) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () => context.read<MovieListBloc>().add(const LoadPopular(forceRefresh: true)),
                );
              }
              final movies = (state as MovieListLoaded).movies;
              return _HomeLoaded(movies: movies);
            },
          ),
        ),
      ),
    );
  }
}

class _HomeLoaded extends StatelessWidget {
  final List<Movie> movies;
  const _HomeLoaded({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          HomeHero(movies: movies),

          PopularMoviesSection(movies: movies),
          PopularTVSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(height: 420, color: Colors.white12),
        const SizedBox(height: 16),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _ShimmerBox(width: 220, height: 22)),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) => const _ShimmerBox(width: 160, height: 230, radius: 18),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: 6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const _ShimmerBox({super.key, required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white70, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
