part of 'tv_bloc.dart';

abstract class TvEvent extends Equatable {
  const TvEvent();
  @override
  List<Object?> get props => [];
}

class LoadPopularTv extends TvEvent {
  const LoadPopularTv();
}
