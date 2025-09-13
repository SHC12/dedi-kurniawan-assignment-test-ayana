part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();
  @override
  List<Object?> get props => [];
}

class LoadPopular extends MovieListEvent {
  final bool forceRefresh;
  const LoadPopular({this.forceRefresh = false});
}
