import 'package:ayana_movies/presentation/screens/explore/explore_screen.dart';
import 'package:ayana_movies/presentation/screens/favorites/favorites_screen.dart';
import 'package:ayana_movies/presentation/screens/home/home_screen.dart';
import 'package:ayana_movies/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../domain/usecases/favorites_movie.dart';
import '../domain/usecases/get_popular_tv.dart';
import '../domain/usecases/favorites_tv.dart';
import 'bloc/favorites/favorites_cubit.dart';
import 'bloc/movie_list/movie_list_bloc.dart';
import 'bloc/navigation/navigation_cubit.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/tv/tv_bloc.dart';
import 'screens/shared/widgets/bottom_nav.dart';

class RootNavScreen extends StatelessWidget {
  const RootNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => MovieListBloc(sl<GetPopularMovies>())..add(const LoadPopular())),
        BlocProvider(create: (_) => TvBloc(sl<GetPopularTv>())..add(const LoadPopularTv())),
        BlocProvider(create: (_) => SearchBloc(sl<SearchMovies>())),
        BlocProvider(create: (_) => FavoritesCubit(sl<FavoritesMovie>(), sl<FavoritesTv>())),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          final pages = [const HomeScreen(), ExploreScreen(), const FavoritesScreen(), const ProfileScreen()];

          return Scaffold(
            body: IndexedStack(index: index, children: pages),
            bottomNavigationBar: BottomNav(currentIndex: index, onTap: context.read<NavigationCubit>().select),
          );
        },
      ),
    );
  }
}
