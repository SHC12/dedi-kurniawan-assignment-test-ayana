import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../core/failure.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies getPopular;
  MovieListBloc(this.getPopular) : super(MovieListInitial()) {
    on<LoadPopular>((event, emit) async {
      emit(MovieListLoading());
      final res = await getPopular(forceRefresh: event.forceRefresh);
      res.fold((Failure f) => emit(MovieListError(f.message)), (List<Movie> movies) => emit(MovieListLoaded(movies)));
    });
  }
}
