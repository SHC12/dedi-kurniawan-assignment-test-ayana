part of 'tv_bloc.dart';

abstract class TvState extends Equatable {
  const TvState();
  @override
  List<Object?> get props => [];
}

class TvLoading extends TvState {}

class TvLoaded extends TvState {
  final List<TvShow> items;
  const TvLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class TvError extends TvState {
  final String message;
  const TvError(this.message);
  @override
  List<Object?> get props => [message];
}
