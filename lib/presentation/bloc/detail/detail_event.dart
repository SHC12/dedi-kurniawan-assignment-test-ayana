part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadDetail extends DetailEvent {
  final int id;
  final MediaKind kind;
  const LoadDetail(this.id, this.kind);
}

class ToggleFavoriteEvent extends DetailEvent {}
