part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object?> get props => [];
}

class ExploreStarted extends ExploreEvent {
  const ExploreStarted();
}

class ExploreQueryChanged extends ExploreEvent {
  final String query;
  const ExploreQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ExploreApplyFilter extends ExploreEvent {
  final String category;
  final Set<String> genres;
  final int? year;
  final String country;
  final String sortBy;
  const ExploreApplyFilter({
    required this.category,
    required this.genres,
    required this.year,
    required this.country,
    required this.sortBy,
  });
}

class ExploreRetry extends ExploreEvent {
  const ExploreRetry();
}
