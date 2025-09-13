part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
  const DetailInitial();
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailLoaded extends DetailState {
  final DetailVM vm;
  final bool isFavorite;
  const DetailLoaded({required this.vm, required this.isFavorite});

  @override
  List<Object?> get props => [vm, isFavorite];
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);
  @override
  List<Object?> get props => [message];
}
