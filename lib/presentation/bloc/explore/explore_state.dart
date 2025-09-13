part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  final String category;
  final Set<String> genres;
  final int? year;
  final String country;
  final String sortBy;

  const ExploreState({
    required this.category,
    required this.genres,
    required this.year,
    required this.country,
    required this.sortBy,
  });

  @override
  List<Object?> get props => [category, genres, year, country, sortBy];
}

class ExploreLoading extends ExploreState {
  const ExploreLoading() : super(category: 'All', genres: const {}, year: null, country: 'All', sortBy: 'Recommended');
}

class ExploreSearching extends ExploreState {
  final String query;
  const ExploreSearching({
    required this.query,
    required super.category,
    required super.genres,
    required super.year,
    required super.country,
    required super.sortBy,
  });

  @override
  List<Object?> get props => super.props..add(query);
}

class ExploreLoaded extends ExploreState {
  final List<Media> base;
  final List<Media> results;
  final String query;

  const ExploreLoaded({
    required this.base,
    required this.results,
    required this.query,
    required super.category,
    required super.genres,
    required super.year,
    required super.country,
    required super.sortBy,
  });

  ExploreLoaded copyWith({
    List<Media>? base,
    List<Media>? results,
    String? query,
    String? category,
    Set<String>? genres,
    int? year,
    String? country,
    String? sortBy,
  }) {
    return ExploreLoaded(
      base: base ?? this.base,
      results: results ?? this.results,
      query: query ?? this.query,
      category: category ?? this.category,
      genres: genres ?? this.genres,
      year: year ?? this.year,
      country: country ?? this.country,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => super.props..addAll([base, results, query]);
}

class ExploreEmpty extends ExploreState {
  final String query;
  const ExploreEmpty({
    required this.query,
    required super.category,
    required super.genres,
    required super.year,
    required super.country,
    required super.sortBy,
  });
  @override
  List<Object?> get props => super.props..add(query);
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message)
    : super(category: 'All', genres: const {}, year: null, country: 'All', sortBy: 'Recommended');

  @override
  List<Object?> get props => super.props..add(message);
}
