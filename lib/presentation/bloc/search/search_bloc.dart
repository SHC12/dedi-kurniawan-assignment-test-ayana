import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/search_movies.dart';
import '../../../core/failure.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  SearchBloc(this.searchMovies) : super(SearchIdle()) {
    on<DoSearch>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(SearchIdle());
        return;
      }
      emit(SearchLoading());
      final res = await searchMovies(event.query, forceRefresh: event.forceRefresh);
      res.fold((Failure f) => emit(SearchError(f.message)), (List<Movie> list) => emit(SearchLoaded(list)));
    });
  }
}
